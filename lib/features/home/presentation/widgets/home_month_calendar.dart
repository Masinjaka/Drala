import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_activity_marker.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeMonthCalendar extends StatelessWidget {
  const HomeMonthCalendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.today,
    required this.activityDates,
    required this.onDaySelected,
    required this.onPageChanged,
    super.key,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
  final DateTime today;
  final Set<DateTime> activityDates;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

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
    final dayStyle = TextStyle(
        color: colors.onSurface, fontSize: 14, fontWeight: FontWeight.w400);
    final weekdayStyle = TextStyle(
        color: colors.onSurfaceVariant,
        fontSize: 10,
        fontWeight: FontWeight.w400);
    return TableCalendar<DateTime>(
      key: const Key('home-month-calendar'),
      locale: Localizations.localeOf(context).toLanguageTag(),
      firstDay: DateTime(2000),
      lastDay: DateUtils.dateOnly(today),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      sixWeekMonthsEnforced: false,
      availableGestures: AvailableGestures.horizontalSwipe,
      headerVisible: false,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      rowHeight: rowHeight,
      daysOfWeekHeight: weekdaysHeight,
      selectedDayPredicate: (day) => DateUtils.isSameDay(day, selectedDay),
      onDaySelected: (day, _) => onDaySelected(DateUtils.dateOnly(day)),
      onPageChanged: onPageChanged,
      eventLoader: (day) =>
          activityDates.contains(DateUtils.dateOnly(day)) ? [day] : const [],
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
          border: Border.all(color: colors.onSurface),
          borderRadius: BorderRadius.circular(10),
        ),
        cellMargin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        markersAlignment: Alignment.bottomCenter,
      ),
    );
  }
}
