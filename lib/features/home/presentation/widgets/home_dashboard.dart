import 'package:budgets/core/ui/app_header_scope.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard_header.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/controllers/home_entry_actions.dart';
import 'package:budgets/features/home/presentation/widgets/activities_calendar_card.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_sliver_delegate.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:budgets/features/ads/presentation/widgets/home_native_ad.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:flutter/material.dart';
import 'ai_credit_button.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard(
      {required this.today,
      required this.viewModel,
      required this.notificationViewModel,
      required this.onNotificationsPressed,
      required this.onFinanceChanged,
      required this.onDateSelected,
      this.currencyState,
      this.activityCalendarViewModel,
      this.isCurrencyLoading = false,
      this.manualOnly = false,
      super.key});
  final DateTime today;
  final AiEntryViewModel viewModel;
  final FinanceNotificationViewModel notificationViewModel;
  final VoidCallback onNotificationsPressed;
  final Future<void> Function() onFinanceChanged;
  final ValueChanged<DateTime> onDateSelected;
  final CurrencyState? currencyState;
  final ActivityCalendarViewModel? activityCalendarViewModel;
  final bool isCurrencyLoading;
  final bool manualOnly;

  @override
  Widget build(BuildContext context) {
    final actions = HomeEntryActions(viewModel, currencyState: currencyState);
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => ColoredBox(
              key: const Key('home-dashboard-background'),
              color: AppActivitiesTheme.background(context),
              child: SafeArea(
                bottom: false,
                child: Column(children: [
                  AppHeaderScope(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: AppHeaderMetrics.topPadding, bottom: 20),
                      child: HomeDashboardHeader(
                          aiCredits: manualOnly ||
                                  (viewModel.remainingRequests == null &&
                                      !viewModel.hasUnlimitedAiRequests)
                              ? null
                              : AiCreditButton(
                                  remaining: viewModel.remainingRequests,
                                  unlimited: viewModel.hasUnlimitedAiRequests),
                          notificationViewModel: notificationViewModel,
                          onNotificationsPressed: onNotificationsPressed),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.depth == 0 &&
                            notification.metrics.extentAfter < 240) {
                          viewModel.loadMoreEntries();
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                          onRefresh: () async {
                            try {
                              await viewModel.loadDate(viewModel.selectedDate);
                              await onFinanceChanged();
                            } catch (error) {
                              if (context.mounted) {
                                showErrorToast(context, error);
                              }
                            }
                          },
                          child: CustomScrollView(
                            key: const Key('transaction-scroll-view'),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              ActivitiesCalendarCard(
                                  today: today,
                                  selectedDate: viewModel.selectedDate,
                                  activity: activityCalendarViewModel,
                                  onDateSelected: onDateSelected),
                              HomeOperationsList(
                                  onCreate: () async {
                                    await actions.addManual(context);
                                    await onFinanceChanged();
                                  },
                                  asSliver: true,
                                  entries: viewModel.entries,
                                  isLoading: !viewModel.entriesResolved &&
                                      !viewModel.entriesLoadFailed,
                                  resolved: viewModel.entriesResolved,
                                  date: viewModel.selectedDate,
                                  isLoadingMore: viewModel.isLoadingMoreEntries,
                                  isAdding: viewModel.isAddingEntry,
                                  pendingEdits: viewModel.pendingEdits,
                                  currencyState: currencyState,
                                  onEntryTap: (entry) async {
                                    await actions.editEntry(context, entry);
                                    await onFinanceChanged();
                                  }),
                              if (!manualOnly)
                                const SliverToBoxAdapter(child: HomeNativeAd()),
                              SliverLayoutBuilder(
                                  builder: (context, constraints) {
                                final remaining =
                                    (constraints.viewportMainAxisExtent +
                                            HomeCalendarSliverDelegate
                                                .controlsHeight -
                                            constraints.precedingScrollExtent)
                                        .clamp(24.0, double.infinity);
                                return SliverToBoxAdapter(
                                    child: SizedBox(height: remaining));
                              }),
                            ],
                          )),
                    ),
                  ),
                ]),
              ),
            ));
  }
}
