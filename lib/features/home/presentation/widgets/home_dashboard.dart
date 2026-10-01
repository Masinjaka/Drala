import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard_header.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/controllers/home_entry_actions.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_panel.dart';
import 'package:budgets/features/home/presentation/widgets/home_scroll_layout.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({
    required this.today,
    required this.drawerProgress,
    required this.onMenuPressed,
    required this.viewModel,
    required this.notificationViewModel,
    required this.onNotificationsPressed,
    required this.onFinanceChanged,
    required this.onDateSelected,
    this.currencyState,
    this.activityCalendarViewModel,
    this.isCurrencyLoading = false,
    super.key,
  });

  final DateTime today;
  final Animation<double> drawerProgress;
  final VoidCallback onMenuPressed;
  final AiEntryViewModel viewModel;
  final FinanceNotificationViewModel notificationViewModel;
  final VoidCallback onNotificationsPressed;
  final Future<void> Function() onFinanceChanged;
  final ValueChanged<DateTime> onDateSelected;
  final CurrencyState? currencyState;
  final ActivityCalendarViewModel? activityCalendarViewModel;
  final bool isCurrencyLoading;

  @override
  Widget build(BuildContext context) {
    final actions = HomeEntryActions(viewModel, currencyState: currencyState);
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => ColoredBox(
        key: const Key('home-dashboard-background'),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: HomeScrollLayout(
              header: HomeDashboardHeader(
                drawerProgress: drawerProgress,
                onMenuPressed: onMenuPressed,
                notificationViewModel: notificationViewModel,
                onNotificationsPressed: onNotificationsPressed,
              ),
              banner: Padding(
                padding: const EdgeInsets.only(left: 30, right: 28),
                child: HomeBalanceCard(
                  balance: _balance,
                  income: _income,
                  expenses: _expenses,
                  isLoading: viewModel.isSummaryLoading || isCurrencyLoading,
                  currencyCode:
                      currencyState?.code ?? viewModel.walletCurrencyCode,
                ),
              ),
              calendarBuilder: (compact, onVisibilityChanged) => HomeWeekPanel(
                onControlsVisibilityChanged: onVisibilityChanged,
                compact: compact,
                activityViewModel: activityCalendarViewModel,
                selectedDate: viewModel.selectedDate,
                today: today,
                onDateSelected: onDateSelected,
              ),
              transactions: HomeOperationsList(
                asSliver: true,
                entries: viewModel.entries,
                isLoading: viewModel.isLoading,
                isAdding: viewModel.isAddingEntry,
                pendingEdits: viewModel.pendingEdits,
                currencyState: currencyState,
                onEntryTap: (entry) async {
                  await actions.editEntry(context, entry);
                  await onFinanceChanged();
                },
              ),
              composer: ChatInputBar(
                isSubmitting: viewModel.isSubmitting,
                currencyCode:
                    currencyState?.code ?? viewModel.walletCurrencyCode,
                isQuotaExhausted: !viewModel.hasUnlimitedAiRequests &&
                    viewModel.remainingRequests == 0,
                onSubmit: (message) => _refreshAfter(
                  () => actions.submitMessage(context, message),
                ),
                onReceiptSubmit: (input) => _refreshAfter(
                  () => actions.submitReceipt(context, input),
                ),
                onManualEntryRequested: () async {
                  await actions.addManual(context);
                  await onFinanceChanged();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _refreshAfter(Future<bool> Function() action) async {
    final succeeded = await action();
    if (succeeded) await onFinanceChanged();
    return succeeded;
  }

  num get _balance =>
      currencyState?.convertToSelected(
        viewModel.totalWalletBalance,
        viewModel.walletCurrencyCode,
      ) ??
      viewModel.totalWalletBalance;

  num get _income => viewModel.monthlyIncome;
  num get _expenses => viewModel.monthlyExpenses;
}
