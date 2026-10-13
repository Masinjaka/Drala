import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:flutter/material.dart';

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
    this.currencyState,
    this.isCurrencyLoading = false,
    super.key,
  });

  final DateTime today;
  final AiEntryViewModel viewModel;
  final ActivityCalendarViewModel activityCalendarViewModel;
  final FinanceNotificationViewModel notificationViewModel;
  final VoidCallback onNotificationsPressed;
  final Future<void> Function() onFinanceChanged;
  final ValueChanged<DateTime> onDateSelected;
  final List<Widget> destinations;
  final VoidCallback onActivitiesSelected;
  final CurrencyState? currencyState;
  final bool isCurrencyLoading;

  @override
  State<ChatHomeLayout> createState() => _ChatHomeLayoutState();
}

class _ChatHomeLayoutState extends State<ChatHomeLayout> {
  int _selectedIndex = 0;

  void _select(int index) {
    if (index == _selectedIndex) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _selectedIndex = index);
    if (index == 0) widget.onActivitiesSelected();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(fit: StackFit.expand, children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: TickerMode(
              enabled: _selectedIndex == 0,
              child: ExcludeFocus(
                excluding: _selectedIndex != 0,
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
                ),
              ),
            ),
          ),
          if (_selectedIndex != 0)
            KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: widget.destinations[_selectedIndex - 1],
            ),
        ]),
        bottomNavigationBar: HomeBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onSelected: _select,
        ),
      );
}
