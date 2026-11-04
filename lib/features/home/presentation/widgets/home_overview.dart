import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelopes_section.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transactions_section.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/view_models/home_overview_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_balance.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_flow_pill.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeOverview extends StatelessWidget {
  const HomeOverview(
      {required this.viewModel,
      required this.notifications,
      required this.onNotificationsPressed,
      required this.onActivities,
      required this.onEnvelopes,
      required this.onRefresh,
      this.overview,
      this.onCreateEnvelope,
      this.today,
      this.displayName,
      this.currency,
      this.currencyLoading = false,
      super.key});
  final DateTime? today;
  final String? displayName;
  final AiEntryViewModel viewModel;
  final HomeOverviewViewModel? overview;
  final FinanceNotificationViewModel notifications;
  final VoidCallback onNotificationsPressed;
  final VoidCallback onActivities;
  final VoidCallback onEnvelopes;
  final VoidCallback? onCreateEnvelope;
  final Future<void> Function() onRefresh;
  final CurrencyState? currency;
  final bool currencyLoading;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable:
            Listenable.merge([viewModel, if (overview != null) overview!]),
        builder: (context, _) {
          final balance = currency?.convertToSelected(
                  viewModel.totalWalletBalance, viewModel.walletCurrencyCode) ??
              viewModel.totalWalletBalance;
          final code = currency?.code ?? viewModel.walletCurrencyCode;
          final entries =
              overview?.recentEntries ?? viewModel.entries.take(4).toList();
          final envelopes = overview?.envelopes ?? [];
          final loading = overview?.isLoading ?? viewModel.isLoading;
          final monthly = overview?.monthlyEntries ?? [];
          num total(bool income) => monthly
              .where((entry) => income ? entry.isIncome : entry.isExpense)
              .fold<num>(
                  0,
                  (sum, entry) =>
                      sum +
                      (currency?.convertToSelected(
                              entry.amount, entry.currencyCode) ??
                          entry.amount));
          return AppGridBackground(
              gravity: true,
              backgroundColor: AppHomeOverviewTheme.background(context),
              amount: balance,
              loading: viewModel.isSummaryLoading || currencyLoading,
              builder: (balanceKey) => SafeArea(
                  bottom: false,
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      key: const Key('home-overview-scroll'),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                          child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Padding(
                          padding: AppPageSpacing.insets(context,
                              top: AppHeaderMetrics.topPadding, bottom: 8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomeOverviewHeader(
                                    today: today ?? DateTime.now(),
                                    displayName: displayName,
                                    notifications: notifications,
                                    onNotificationsPressed:
                                        onNotificationsPressed),
                                const SizedBox(height: 12),
                                HomeOverviewBalance(
                                    amountKey: balanceKey,
                                    balance: balance,
                                    currencyCode: code,
                                    loading: viewModel.isSummaryLoading ||
                                        currencyLoading),
                                const SizedBox(height: 16),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Row(children: [
                                      Expanded(
                                          child: HomeOverviewFlowPill(
                                              amount: total(true),
                                              currencyCode: code,
                                              income: true,
                                              label: context.l10n.income,
                                              loading:
                                                  loading || currencyLoading,
                                              onPressed: onActivities)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                          child: HomeOverviewFlowPill(
                                              amount: total(false),
                                              currencyCode: code,
                                              income: false,
                                              label: context.l10n.expenses,
                                              loading:
                                                  loading || currencyLoading,
                                              onPressed: onActivities)),
                                    ])),
                                if (overview?.error != null)
                                  TextButton.icon(
                                      onPressed: onRefresh,
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: Text(
                                          context.l10n.overviewLoadFailed)),
                                const SizedBox(height: 32),
                                HomeOverviewEnvelopesSection(
                                    envelopes: envelopes,
                                    loading: loading,
                                    onEnvelopes: onEnvelopes,
                                    onCreate: onCreateEnvelope ?? onEnvelopes,
                                    currency: currency),
                                const SizedBox(height: 4),
                                HomeOverviewTransactionsSection(
                                    entries: entries,
                                    loading: loading,
                                    viewModel: viewModel,
                                    onActivities: onActivities,
                                    onRefresh: onRefresh,
                                    currency: currency),
                              ]),
                        ),
                      )),
                    ),
                  )));
        },
      );
}
