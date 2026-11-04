import 'dart:async';
import 'package:budgets/core/monitoring/development_log.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/data/services/supabase_offline_remote.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineSyncManager extends ChangeNotifier with WidgetsBindingObserver {
  OfflineSyncManager(this.client, this.connectivity,
      {OfflineAccount Function(String id)? createAccount})
      : _createAccount = createAccount;
  final OfflineAccount Function(String id)? _createAccount;
  final SupabaseClient client;
  final OfflineConnectivity connectivity;
  OfflineAccount? account;
  bool opening = false;
  StreamSubscription<AuthState>? _auth;
  int _generation = 0;
  String? _selectedId;
  bool _closed = false;
  bool _foreground = true;
  Future<void>? _starting;
  Future<void>? _closing;
  Future<void> _switching = Future.value();

  Future<void> start() {
    if (_closed) return Future.value();
    return _starting ??= _start();
  }

  Future<void> _start() async {
    WidgetsBinding.instance.addObserver(this);
    connectivity.addListener(_networkChanged);
    _auth = client.auth.onAuthStateChange.listen((event) {
      if (_closed) return;
      if (event.session?.user.id != _selectedId) {
        unawaited(_switchAccount());
      } else if (event.session != null &&
          account?.status.name == 'signInRequired') {
        unawaited(account?.retry());
      }
    }, onError: (Object error, StackTrace stack) {
      connectivity.failed(error);
    });
    await _switchAccount();
  }

  Future<void> _switchAccount() async {
    if (_closed) return;
    final generation = ++_generation;
    final id = client.auth.currentUser?.id;
    _selectedId = id;
    // Finish opening and closing the previous owner before constructing another.
    final previous = _switching;
    _switching = previous.then((_) => _openAccount(id, generation));
    await _switching;
  }

  Future<void> _openAccount(String? id, int generation) async {
    if (_closed || generation != _generation) return;
    final old = account;
    account = null;
    opening = id != null;
    notifyListeners();
    old?.removeListener(_changed);
    OfflineAccount? next;
    try {
      if (old != null) await old.close();
      if (id == null || _closed || generation != _generation) return;
      next = _createAccount?.call(id) ??
          OfflineAccount(GuestDatabase.account(id),
              SupabaseOfflineRemote(client, id), connectivity);
      await next.initialize();
      if (_closed || generation != _generation) {
        await next.close();
        return;
      }
      account = next;
      opening = false;
      next.addListener(_changed);
      next.setActive(_foreground);
      notifyListeners();
    } catch (error, stack) {
      await next?.close();
      if (generation != _generation || _closed) return;
      opening = false;
      DevelopmentLog.error('open offline database', error, stack);
      notifyListeners();
    }
  }

  Future<void> retryOpen() => _switchAccount();
  void _changed() {
    if (!_closed) notifyListeners();
  }

  void _networkChanged() {
    if (connectivity.isOffline) account?.networkFailed();
    _changed();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    account?.setActive(_foreground);
  }

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    _closed = true;
    _generation++;
    WidgetsBinding.instance.removeObserver(this);
    connectivity.removeListener(_networkChanged);
    await _auth?.cancel();
    await _switching;
    account?.removeListener(_changed);
    await account?.close();
    account = null;
    opening = false;
    super.dispose();
  }
}
