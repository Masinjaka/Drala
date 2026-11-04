import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_selection_indicator.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_activity_marker.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:intl/intl.dart';

class HomeWeekStrip extends StatelessWidget {
  const HomeWeekStrip({
    required this.selectedDate,
    required this.today,
    required this.onDateSelected,
    this.activityDates = const {},
    this.focusedDate,
    this.filledSelection = false,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDateSelected;
  final Set<DateTime> activityDates;
  final DateTime? focusedDate;
  final bool filledSelection;

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
      child: LayoutBuilder(builder: (context, constraints) {
        final selectedIndex = DateTime.utc(
                selectedDate.year, selectedDate.month, selectedDate.day)
            .difference(DateTime.utc(start.year, start.month, start.day))
            .inDays;
        return Stack(fit: StackFit.expand, children: [
          if (filledSelection && selectedIndex >= 0 && selectedIndex < 7)
            CalendarSelectionIndicator(
                bounds: Rect.fromLTWH(
                    selectedIndex * constraints.maxWidth / 7 + 4,
                    0,
                    (constraints.maxWidth / 7 - 8).clamp(0, double.infinity),
                    heightFor(context))),
          Row(
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
                    border: selected && !filledSelection
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
                        style: filledSelection
                            ? AppActivitiesTheme.weekday(context,
                                enabled: enabled)
                            : AppTextStyle(AppTextRole.caption,
                                height: 1.2,
                                color: enabled
                                    ? null
                                    : Theme.of(context).disabledColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${date.day}',
                        maxLines: 1,
                        style: filledSelection
                            ? AppActivitiesTheme.day(context, enabled: enabled)
                            : AppTextStyle(AppTextRole.body,
                                height: 1.2,
                                color: enabled
                                    ? null
                                    : Theme.of(context).disabledColor),
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
          })),
        ]);
      }),
    );
  }
}
