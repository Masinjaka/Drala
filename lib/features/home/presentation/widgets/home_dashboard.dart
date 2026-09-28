import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/controllers/home_entry_actions.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_notification_button.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_strip.dart';
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedBuilder(
                        animation: drawerProgress,
                        builder: (context, child) => Opacity(
                          opacity: 1 - drawerProgress.value,
                          child: IgnorePointer(
                            ignoring: drawerProgress.value > 0,
                            child: child,
                          ),
                        ),
                        child: OutlinedSquareButton(
                          key: const Key('home-menu-button'),
                          icon: Icons.menu_rounded,
                          onPressed: onMenuPressed,
                        ),
                      ),
                      HomeNotificationButton(
                        viewModel: notificationViewModel,
                        onPressed: onNotificationsPressed,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 13),
                Padding(
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
                const SizedBox(height: 23),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29),
                  child: HomeWeekStrip(
                    selectedDate: viewModel.selectedDate,
                    today: today,
                    onDateSelected: onDateSelected,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: HomeOperationsList(
                            entries: viewModel.entries,
                            isLoading: viewModel.isLoading,
                            isAdding: viewModel.isSubmitting,
                            currencyState: currencyState,
                            onEntryTap: (entry) async {
                              await actions.editEntry(context, entry);
                              await onFinanceChanged();
                            },
                          ),
                        ),
                        ChatInputBar(
                          isSubmitting: viewModel.isSubmitting,
                          currencyCode: currencyState?.code ??
                              viewModel.walletCurrencyCode,
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
                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
              ],
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
