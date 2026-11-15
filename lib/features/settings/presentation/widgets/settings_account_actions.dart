import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/offline/domain/providers/offline_providers.dart';
import 'package:budgets/features/settings/data/repositories/supabase_account_data_repository.dart';
import 'package:budgets/features/settings/data/repositories/unavailable_account_data_repository.dart';
import 'package:budgets/features/settings/data/services/account_data_service.dart';
import 'package:budgets/features/settings/presentation/view_models/danger_zone_view_model.dart';
import 'package:budgets/features/settings/presentation/widgets/danger_zone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsAccountActions extends ConsumerStatefulWidget {
  const SettingsAccountActions({this.onDataDeleted, super.key});

  final VoidCallback? onDataDeleted;

  @override
  ConsumerState<SettingsAccountActions> createState() =>
      _SettingsAccountActionsState();
}

class _SettingsAccountActionsState extends ConsumerState<SettingsAccountActions>
    with AutomaticKeepAliveClientMixin {
  late final _client = _supabaseClient();
  late final _viewModel = DangerZoneViewModel(
    _client == null
        ? const UnavailableAccountDataRepository()
        : SupabaseAccountDataRepository(AccountDataService(
            _client,
            offline: ref.read(offlineAccountProvider),
          )),
  );
  bool _isLoggingOut = false;

  @override
  bool get wantKeepAlive => true;

  SupabaseClient? _supabaseClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DangerZone(
      viewModel: _viewModel,
      accountEmail: _client?.auth.currentUser?.email ?? '',
      onLogout: _logout,
      isLoggingOut: _isLoggingOut,
      onDataDeleted: _dataDeleted,
      onAccountDeleted: () => context.go('/getting-started'),
    );
  }

  void _dataDeleted() {
    widget.onDataDeleted?.call();
    if (!mounted) return;
    if (widget.onDataDeleted == null) {
      context.go('/home');
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    await ref.read(authControllerProvider.notifier).signOut();
    if (!mounted) return;
    context.go('/home');
  }
}
