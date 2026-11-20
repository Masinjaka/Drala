import 'package:budgets/core/ui/app_loader.dart';
import 'package:budgets/features/offline/data/repositories/offline_receipt_repository.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/home/data/services/home_repository_factory.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/features/offline/data/repositories/offline_ai_entry_repository.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
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
        if (!account.hydrated) {
          if (status == SyncStatus.syncing || status == SyncStatus.connecting) {
            return const Scaffold(
                body: Center(child: AppLoader()));
          }
          return Scaffold(
              body: Center(
                  child: IconButton(
                      onPressed: _retry,
                      tooltip: context.l10n.offlineRetry,
                      icon: const Icon(Icons.refresh_rounded))));
        }
        return ChatHomePage(
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
      });
}
