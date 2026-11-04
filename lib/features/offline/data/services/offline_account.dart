import 'dart:async';
import 'dart:math' as math;
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/data/services/offline_outbox_store.dart';
import 'package:budgets/features/offline/data/services/offline_snapshot_store.dart';
import 'package:budgets/features/offline/data/services/offline_sync_engine.dart';
import 'package:budgets/features/offline/domain/models/offline_unavailable_exception.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import 'package:budgets/features/offline/domain/repositories/offline_remote.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineAccount extends ChangeNotifier {
  OfflineAccount(this.database, this.remote, this.connectivity)
      : local = GuestRepositories(database, remote.accountId),
        outbox = OfflineOutboxStore(database),
        engine = OfflineSyncEngine(remote, OfflineOutboxStore(database),
            OfflineSnapshotStore(database, remote.accountId));
  final GuestDatabase database;
  final OfflineRemote remote;
  final OfflineConnectivity connectivity;
  final GuestRepositories local;
  final OfflineOutboxStore outbox;
  final OfflineSyncEngine engine;
  String get id => remote.accountId;
  SyncStatus status = SyncStatus.connecting;
  bool hydrated = false;
  int pending = 0;
  int dataVersion = 0;
  Object? lastError;
  bool _closed = false;
  bool _active = true;
  int _failures = 0;
  Timer? _timer;
  Future<void>? _running;
  StreamSubscription<void>? _journal;

  Future<void> initialize() async {
    hydrated = await outbox.state('hydrated') == '1';
    pending = await outbox.count();
    _journal = database.syncChanges.listen((_) {
      _schedule(const Duration(milliseconds: 350));
    });
  }

  void requireOnline() {
    if (status != SyncStatus.online || pending != 0) {
      throw OfflineUnavailableException(needsDownload: !hydrated);
    }
  }

  void setActive(bool active) {
    _active = active;
    _timer?.cancel();
    if (active) _schedule(Duration.zero);
  }

  void networkFailed() {
    if (_closed) return;
    status = SyncStatus.offline;
    notifyListeners();
    _schedule(const Duration(seconds: 5));
  }

  Future<void> synchronize() =>
      _running ??= _sync().whenComplete(() => _running = null);
  Future<void> _sync() async {
    if (_closed || !_active) return;
    _timer?.cancel();
    try {
      pending = await outbox.count();
      if (status == SyncStatus.conflict ||
          status == SyncStatus.blocked ||
          status == SyncStatus.signInRequired) {
        notifyListeners();
        return;
      }
      if (!hydrated || pending > 0) {
        status = SyncStatus.syncing;
        notifyListeners();
      }
      final changed = await engine.sync();
      if (_closed) return;
      hydrated = await outbox.state('hydrated') == '1';
      pending = await outbox.count();
      if (changed) dataVersion++;
      lastError = null;
      status = SyncStatus.online;
      _failures = 0;
      connectivity.recovered();
      notifyListeners();
      _schedule(const Duration(seconds: 45));
    } catch (error) {
      if (_closed) return;
      lastError = error;
      if (OfflineConnectivity.isNetworkError(error)) {
        status = SyncStatus.offline;
        connectivity.failed(error);
      } else if (error is PostgrestException &&
          error.message.contains('offline_sync_conflict')) {
        status = SyncStatus.conflict;
      } else if (error is AuthException ||
          error is PostgrestException &&
              {'PGRST301', 'PGRST303', '28000'}.contains(error.code)) {
        status = SyncStatus.signInRequired;
      } else if (error is StateError &&
              {'offline_snapshot_changed', 'offline_local_edits_pending'}
                  .contains(error.message) ||
          error is PostgrestException &&
              {'40001', '40P01'}.contains(error.code)) {
        status = SyncStatus.connecting;
      } else {
        status = SyncStatus.blocked;
      }
      if (!OfflineConnectivity.isNetworkError(error) &&
          (error is PostgrestException || error is AuthException)) {
        connectivity.recovered();
      }
      notifyListeners();
      if (status == SyncStatus.offline || status == SyncStatus.connecting) {
        _failures++;
        _schedule(Duration(
            seconds: math.min(60, 5 * (1 << math.min(_failures - 1, 4)))));
      }
    }
  }

  Future<void> resetAfterCloudDeletion() async {
    await database.clearAllData();
    hydrated = false;
    pending = 0;
    dataVersion++;
    status = SyncStatus.connecting;
    if (!_closed) notifyListeners();
  }

  Future<void> retry() async {
    if (_running != null) await _running;
    if (status == SyncStatus.conflict) return; // Requires explicit review.
    status = SyncStatus.connecting;
    await synchronize();
  }

  Future<void> retryReviewedChanges() async {
    if (_running != null) await _running;
    await outbox.rebase(await remote.revision());
    status = SyncStatus.connecting;
    await synchronize();
  }

  Future<void> useCloudAfterReview() async {
    if (_running != null) await _running;
    await outbox.discard();
    hydrated = false;
    status = SyncStatus.connecting;
    await synchronize();
  }

  void _schedule(Duration duration) {
    _timer?.cancel();
    if (_closed || !_active) return;
    _timer = Timer(duration, () => unawaited(synchronize()));
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _timer?.cancel();
    await _journal?.cancel();
    await _running;
    await database.close();
    super.dispose();
  }
}
