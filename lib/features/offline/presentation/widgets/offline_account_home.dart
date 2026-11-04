import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/features/offline/data/repositories/offline_receipt_repository.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/home/data/services/home_repository_factory.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/features/offline/data/repositories/offline_ai_entry_repository.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import 'package:budgets/features/offline/presentation/widgets/offline_sync_review_sheet.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class OfflineAccountHome extends StatefulWidget {
  const OfflineAccountHome(
      {required this.account,
      required this.isSignedIn,
      this.displayName,
      this.currency,
      this.currencyLoading = false,
      super.key});
  final OfflineAccount account;
  final bool Function() isSignedIn;
  final String? displayName;
  final CurrencyState? currency;
  final bool currencyLoading;
  @override
  State<OfflineAccountHome> createState() => _OfflineAccountHomeState();
}

class _OfflineAccountHomeState extends State<OfflineAccountHome> {
  late final _remote = HomeRepositoryFactory.create(DateTime.now());
  late final _finance = OfflineAiEntryRepository(widget.account, _remote.ai);
  Future<void> _retry() async {
    try {
      await widget.account.retry();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.account,
      builder: (context, _) {
        final account = widget.account;
        final status = account.status;
        final message = switch (status) {
          SyncStatus.offline => context.l10n.offlineStatus,
          SyncStatus.conflict => context.l10n.syncConflictTitle,
          SyncStatus.blocked => context.l10n.offlineSetupUnavailable,
          SyncStatus.signInRequired => context.l10n.signInSyncRequired,
          _ => context.l10n.syncingStatus,
        };
        if (!account.hydrated) {
          return Scaffold(
              body: SafeArea(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            if (status == SyncStatus.syncing ||
                                status == SyncStatus.connecting)
                              const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(context.l10n.offlineInitial),
                            const SizedBox(height: 8),
                            Text(message),
                            TextButton(
                                onPressed: _retry,
                                child: Text(context.l10n.offlineRetry)),
                          ])))));
        }
        final home = ChatHomePage(
            key: ValueKey(account.id),
            displayName: widget.displayName,
            isSignedIn: widget.isSignedIn,
            aiEntryRepository: _finance,
            envelopeRepository: account.local.envelopeRepository,
            statsRepository: account.local.stats,
            notificationRepository:
                GuestNotificationRepository(account.database, account.id),
            currencyState: widget.currency,
            isCurrencyLoading: widget.currencyLoading,
            manualOnly: status != SyncStatus.online,
            offlineAccount: account,
            receiptRepository: _remote.receipts == null
                ? null
                : OfflineReceiptRepository(account, _remote.receipts!));
        final showStatus = status != SyncStatus.online || account.pending > 0;
        return SafeArea(
            top: showStatus,
            bottom: false,
            child: Column(children: [
              Visibility(
                  visible: showStatus,
                  child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(children: [
                            Icon(
                                status == SyncStatus.offline
                                    ? Icons.cloud_off_outlined
                                    : Icons.sync_rounded,
                                size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(message,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  if (account.pending > 0)
                                    Text(
                                        context.l10n
                                            .pendingStatus(account.pending),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall)
                                ])),
                            TextButton(
                                onPressed: (status == SyncStatus.conflict ||
                                            status == SyncStatus.blocked) &&
                                        account.pending > 0
                                    ? () => showAppSheet<void>(context,
                                        builder: (_) => AppSheetSurface(
                                            heightFactor: .86,
                                            child: OfflineSyncReviewSheet(
                                                account: account)))
                                    : _retry,
                                child: Text((status == SyncStatus.conflict ||
                                            status == SyncStatus.blocked) &&
                                        account.pending > 0
                                    ? context.l10n.offlineReview
                                    : context.l10n.offlineRetry)),
                          ])))),
              Expanded(
                  child: MediaQuery.removePadding(
                      context: context, removeTop: showStatus, child: home)),
            ]));
      });
}
