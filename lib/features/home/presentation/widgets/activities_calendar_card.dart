import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_panel.dart';
import 'package:flutter/material.dart';

class ActivitiesCalendarCard extends StatelessWidget {
  const ActivitiesCalendarCard(
      {required this.today,
      required this.selectedDate,
      required this.onDateSelected,
      this.activity,
      super.key});
  final DateTime today;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final ActivityCalendarViewModel? activity;

  @override
  Widget build(BuildContext context) => HomeWeekPanel(
        today: today,
        selectedDate: selectedDate,
        onDateSelected: onDateSelected,
        activityViewModel: activity,
        activitiesStyle: true,
        compact: MediaQuery.viewInsetsOf(context).bottom > 0 &&
            ModalRoute.of(context)?.isCurrent != false,
      );
}
