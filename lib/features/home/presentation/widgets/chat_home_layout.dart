import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview.dart';
import 'package:budgets/features/home/presentation/view_models/home_overview_view_model.dart';
import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/controllers/home_entry_actions.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/features/home/presentation/widgets/home_activity_composer.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';

class ChatHomeLayout extends StatefulWidget {
  const ChatHomeLayout({
    required this.today,
    required this.viewModel,
    required this.activityCalendarViewModel,
    required this.notificationViewModel,
    required this.onNotificationsPressed,
    required this.onFinanceChanged,
    required this.onDateSelected,
    required this.destinations,
    required this.onActivitiesSelected,
    this.overviewViewModel,
    this.displayName,
    this.currencyState,
    this.isCurrencyLoading = false,
    this.manualOnly = false,
    this.onCreateEnvelope,
    super.key,
  });

  final DateTime today;
  final String? displayName;
  final AiEntryViewModel viewModel;
  final ActivityCalendarViewModel activityCalendarViewModel;
  final FinanceNotificationViewModel notificationViewModel;
  final VoidCallback onNotificationsPressed;
  final Future<void> Function() onFinanceChanged;
  final ValueChanged<DateTime> onDateSelected;
  final List<Widget> destinations;
  final VoidCallback onActivitiesSelected;
  final HomeOverviewViewModel? overviewViewModel;
  final CurrencyState? currencyState;
  final bool isCurrencyLoading;
  final bool manualOnly;
  final VoidCallback? onCreateEnvelope;

  @override
  State<ChatHomeLayout> createState() => _ChatHomeLayoutState();
}

class _ChatHomeLayoutState extends State<ChatHomeLayout> {
  int _selectedIndex = 0;

  void _select(int index) {
    if (index == _selectedIndex) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _selectedIndex = index);
    if (index == 1) widget.onActivitiesSelected();
    if (index == 0) _refreshOverview();
  }

  void _createEnvelope() {
    _select(2);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedIndex == 2) widget.onCreateEnvelope?.call();
    });
  }

  Future<void> _refreshOverview() async {
    try {
      await Future.wait([
        if (widget.overviewViewModel != null) widget.overviewViewModel!.load(),
        widget.viewModel.refreshBalances(),
        widget.onFinanceChanged(),
      ]);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    }
  }

  Future<void> _addManualEntry() async {
    await HomeEntryActions(
      widget.viewModel,
      currencyState: widget.currencyState,
    ).addManual(context);
    if (mounted) await widget.onFinanceChanged();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor:
            _selectedIndex <= 1 ? AppActivitiesTheme.background(context) : null,
        body: Stack(fit: StackFit.expand, children: [
          if (_selectedIndex == 0)
            HomeOverview(
                today: widget.today,
                displayName: widget.displayName,
                viewModel: widget.viewModel,
                overview: widget.overviewViewModel,
                notifications: widget.notificationViewModel,
                onNotificationsPressed: widget.onNotificationsPressed,
                onActivities: () => _select(1),
                onEnvelopes: () => _select(2),
                onCreateEnvelope: _createEnvelope,
                onRefresh: _refreshOverview,
                currency: widget.currencyState,
                currencyLoading: widget.isCurrencyLoading),
          Offstage(
            offstage: _selectedIndex != 1,
            child: TickerMode(
              enabled: _selectedIndex == 1,
              child: ExcludeFocus(
                excluding: _selectedIndex != 1,
                child: HomeDashboard(
                  today: widget.today,
                  viewModel: widget.viewModel,
                  activityCalendarViewModel: widget.activityCalendarViewModel,
                  notificationViewModel: widget.notificationViewModel,
                  onNotificationsPressed: widget.onNotificationsPressed,
                  onFinanceChanged: widget.onFinanceChanged,
                  onDateSelected: widget.onDateSelected,
                  currencyState: widget.currencyState,
                  isCurrencyLoading: widget.isCurrencyLoading,
                  manualOnly: widget.manualOnly,
                ),
              ),
            ),
          ),
          if (_selectedIndex >= 2)
            KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: widget.destinations[_selectedIndex - 2],
            ),
        ]),
        bottomNavigationBar: HomeBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onSelected: _select,
          composer: widget.manualOnly
              ? null
              : HomeActivityComposer(
                  viewModel: widget.viewModel,
                  currency: widget.currencyState,
                  onFinanceChanged: widget.onFinanceChanged),
        ),
        floatingActionButton: widget.manualOnly && _selectedIndex == 1
            ? FloatingActionButton(
                key: const Key('guest-manual-entry-fab'),
                shape: AppButtonTheme.shape,
                onPressed: _addManualEntry,
                tooltip: context.l10n.manualEntry,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: const Icon(Icons.add_rounded),
              )
            : null,
      );
}
