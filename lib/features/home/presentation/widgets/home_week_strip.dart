import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_activity_marker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeWeekStrip extends StatelessWidget {
  const HomeWeekStrip({
    required this.selectedDate,
    required this.today,
    required this.onDateSelected,
    this.activityDates = const {},
    this.focusedDate,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDateSelected;
  final Set<DateTime> activityDates;
  final DateTime? focusedDate;

  static double heightFor(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    return ((scaler.scale(10) + scaler.scale(14)) * 1.2 + 24)
        .clamp(64.0, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    final focused = focusedDate ?? selectedDate;
    final start = DateTime(
        focused.year, focused.month, focused.day - focused.weekday % 7);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return SizedBox(
      height: heightFor(context),
      child: Row(
        children: List.generate(7, (index) {
          final date = DateTime(start.year, start.month, start.day + index);
          final selected = DateUtils.isSameDay(date, selectedDate);
          final enabled = !date.isBefore(DateTime(2000)) &&
              !date.isAfter(DateUtils.dateOnly(today));
          return Expanded(
            child: InkWell(
              key: Key(
                'home-week-day-${DateFormat('yyyy-MM-dd').format(date)}',
              ),
              onTap: enabled ? () => onDateSelected(date) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                key: selected ? const Key('home-week-selected-day') : null,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: selected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      CalendarLabelFormatter.weekday(date, locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          height: 1.2,
                          color:
                              enabled ? null : Theme.of(context).disabledColor,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${date.day}',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                        color: enabled ? null : Theme.of(context).disabledColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 8,
                      child: activityDates.contains(date)
                          ? const HomeCalendarActivityMarker()
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
