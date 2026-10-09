import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/categories/presentation/pages/category_page.dart';
import 'package:budgets/features/feedback/presentation/services/sentry_feedback_launcher.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/presentation/pages/finance_notifications_page.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/features/plans/presentation/pages/plan_page.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/features/settings/presentation/pages/settings_with_back_page.dart';
import 'package:budgets/features/stats/domain/repositories/monthly_stats_repository.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:flutter/material.dart';

class DrawerDestinationNavigator {
  const DrawerDestinationNavigator({
    required this.context,
    required this.closeDrawer,
    this.onReturn,
    this.shouldRunOnReturn,
    this.onDataDeleted,
    this.envelopeRepository,
    this.statsRepository,
    this.currencyState,
    this.wallets = const [],
    this.onAddWallet,
    this.onUpdateWallet,
    this.onDeleteWallet,
    this.walletsListenable,
    this.walletReader,
  });

  final BuildContext context;
  final VoidCallback closeDrawer;
  final Future<void> Function()? onReturn;
  final bool Function()? shouldRunOnReturn;
  final VoidCallback? onDataDeleted;
  final EnvelopeRepository? envelopeRepository;
  final MonthlyStatsRepository? statsRepository;
  final CurrencyState? currencyState;
  final List<WalletSummary> wallets;
  final Future<void> Function(AddWalletInput)? onAddWallet;
  final Future<void> Function(String, AddWalletInput)? onUpdateWallet;
  final Future<void> Function(String)? onDeleteWallet;
  final Listenable? walletsListenable;
  final List<WalletSummary> Function()? walletReader;

  Future<void> openSettings() => _push(
        SettingsWithBackPage(onDataDeleted: onDataDeleted),
      );

  void openPlans() => _push(const PlanPage());

  void openCategories() => _push(const CategoryPage());

  void openWallets() => _push(
        WalletsPage(
          wallets: wallets,
          onAddWallet: onAddWallet ?? (_) async {},
          onUpdateWallet: onUpdateWallet ?? (_, __) async {},
          onDeleteWallet: onDeleteWallet ?? (_) async {},
          currencyState: currencyState,
          walletsListenable: walletsListenable,
          walletReader: walletReader,
        ),
      );

  void openFeedback() => SentryFeedbackLauncher.show(
        context,
        beforeShow: closeDrawer,
      );

  void openEnvelopes() => _push(
        EnvelopePage(
          repository: envelopeRepository,
          displayCurrency: currencyState,
        ),
      );

  void openNotifications(FinanceNotificationViewModel viewModel) => _push(
        FinanceNotificationsPage(
          viewModel: viewModel,
          onSelected: _openNotificationEnvelope,
        ),
      );

  void openStats() => _push(
        FinanceStatsPage(
          repository: statsRepository,
          displayCurrency: currencyState,
        ),
      );

  Future<void> _openNotificationEnvelope(
    BuildContext notificationContext,
    FinanceNotification notification,
  ) {
    return Navigator.of(notificationContext).push(
      MaterialPageRoute<void>(
        builder: (_) => EnvelopePage(
          initialMonth: notification.periodMonth,
          initialEnvelopeId: notification.envelopeId,
          repository: envelopeRepository,
          displayCurrency: currencyState,
        ),
      ),
    );
  }

  Future<void> _push(Widget page) async {
    closeDrawer();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
    if (shouldRunOnReturn?.call() ?? true) {
      await onReturn?.call();
    }
  }
}
