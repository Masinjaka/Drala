import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/activities_calendar_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Sliding calendar selection', size: Size(412, 520))
Widget calendarSelectionPreview() => MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CalendarSelectionPreview(),
    );

class CalendarSelectionPreview extends StatefulWidget {
  const CalendarSelectionPreview({super.key});
  @override
  State<CalendarSelectionPreview> createState() =>
      _CalendarSelectionPreviewState();
}

class _CalendarSelectionPreviewState extends State<CalendarSelectionPreview> {
  DateTime _selected = DateTime(2026, 10, 25);
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: CustomScrollView(
        slivers: [
          ActivitiesCalendarCard(
              today: DateTime(2026, 10, 28),
              selectedDate: _selected,
              onDateSelected: (date) => setState(() => _selected = date))
        ],
      )));
}
