import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import 'package:budgets/features/offline/domain/providers/offline_providers.dart';
import 'package:budgets/features/offline/presentation/widgets/offline_sync_review_sheet.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsSyncFailure extends ConsumerStatefulWidget {
  const SettingsSyncFailure({super.key});

  @override
  ConsumerState<SettingsSyncFailure> createState() =>
      _SettingsSyncFailureState();
}

class _SettingsSyncFailureState extends ConsumerState<SettingsSyncFailure> {
  bool _retrying = false;

  Future<void> _retry(OfflineAccount account) async {
    if (_retrying) return;
    setState(() => _retrying = true);
    try {
      await account.retry();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(offlineAccountProvider);
    if (account == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: account,
      builder: (context, _) {
        final l10n = context.l10n;
        final status = account.status;
        final message = switch (status) {
          SyncStatus.offline when account.lastError != null =>
            l10n.offlineStatus,
          SyncStatus.conflict => l10n.syncConflictTitle,
          SyncStatus.blocked => l10n.offlineSetupUnavailable,
          SyncStatus.signInRequired => l10n.signInSyncRequired,
          _ => null,
        };
        if (message == null) return const SizedBox.shrink();
        final review = status == SyncStatus.conflict ||
            (status == SyncStatus.blocked && account.pending > 0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AppCardSurface(
            color: AppSettingsTheme.surface(context),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.sync_problem_rounded,
                          color: AppSettingsTheme.syncFailureIcon(context),
                          size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(message,
                            style: AppSettingsTheme.menuLabel(context)),
                      ),
                    ],
                  ),
                  if (account.pending > 0)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 32, top: 4),
                      child: Text(l10n.pendingStatus(account.pending),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: review
                          ? () => showAppSheet<void>(context,
                              builder: (_) => AppSheetSurface(
                                  heightFactor: .86,
                                  child:
                                      OfflineSyncReviewSheet(account: account)))
                          : _retrying
                              ? null
                              : () => _retry(account),
                      child:
                          Text(review ? l10n.offlineReview : l10n.offlineRetry),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
