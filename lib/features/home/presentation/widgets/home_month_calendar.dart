import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/features/home/presentation/widgets/month_calendar_selection.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_activity_marker.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeMonthCalendar extends StatelessWidget {
  const HomeMonthCalendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.today,
    required this.activityDates,
    required this.onDaySelected,
    required this.onPageChanged,
    this.filledSelection = false,
    super.key,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final DateTime today;
  final Set<DateTime> activityDates;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;
  final bool filledSelection;

  static const double rowHeight = 40;
  static const double weekdaysHeight = 24;

  static double heightFor(DateTime month) {
    final leadingDays = DateTime(month.year, month.month).weekday % 7;
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final weekCount = ((leadingDays + days) / 7).ceil();
    return weekdaysHeight + weekCount * rowHeight;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dayStyle = filledSelection
        ? AppActivitiesTheme.day(context, enabled: true)
        : AppTextStyle(AppTextRole.input, color: colors.onSurface);
    final weekdayStyle = filledSelection
        ? AppActivitiesTheme.weekday(context, enabled: true)
        : AppTextStyle(AppTextRole.caption, color: colors.onSurfaceVariant);
    Widget calendar(ValueChanged<PageController>? onCreated) =>
        TableCalendar<DateTime>(
          key: const Key('home-month-calendar'),
          onCalendarCreated: onCreated,
          locale: Localizations.localeOf(context).toLanguageTag(),
          firstDay: DateTime(2000),
          lastDay: DateUtils.dateOnly(today),
          focusedDay: focusedDay,
          calendarFormat: CalendarFormat.month,
          sixWeekMonthsEnforced: false,
          availableGestures: AvailableGestures.horizontalSwipe,
          pageAnimationEnabled: !MediaQuery.disableAnimationsOf(context),
          headerVisible: false,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          rowHeight: rowHeight,
          daysOfWeekHeight: weekdaysHeight,
          selectedDayPredicate: (day) => DateUtils.isSameDay(day, selectedDay),
          onDaySelected: (day, _) => onDaySelected(DateUtils.dateOnly(day)),
          onPageChanged: onPageChanged,
          eventLoader: (day) => activityDates.contains(DateUtils.dateOnly(day))
              ? [day]
              : const [],
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return null;
              return const HomeCalendarActivityMarker(size: 6);
            },
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                CalendarLabelFormatter.weekday(date, locale as String?),
            weekdayStyle: weekdayStyle,
            weekendStyle: weekdayStyle,
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            isTodayHighlighted: false,
            defaultTextStyle: dayStyle,
            weekendTextStyle: dayStyle,
            todayTextStyle: dayStyle,
            selectedTextStyle: dayStyle,
            disabledTextStyle: dayStyle.copyWith(color: colors.outline),
            defaultDecoration: const BoxDecoration(),
            weekendDecoration: const BoxDecoration(),
            selectedDecoration: BoxDecoration(
              border:
                  filledSelection ? null : Border.all(color: colors.onSurface),
              borderRadius: BorderRadius.circular(10),
            ),
            cellMargin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            markersAlignment: Alignment.bottomCenter,
          ),
        );
    return filledSelection
        ? MonthCalendarSelection(
            selectedDay: selectedDay,
            focusedDay: focusedDay,
            firstDay: DateTime(2000),
            rowHeight: rowHeight,
            weekdaysHeight: weekdaysHeight,
            builder: calendar)
        : calendar(null);
  }
}
