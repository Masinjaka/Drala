import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ResumeCalendarTheme {
  const ResumeCalendarTheme._();

  static CalendarStyle calendar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final interactive = colors.inverseSurface;
    return CalendarStyle(
      outsideDaysVisible: false,
      defaultTextStyle:
          AppTextStyle(AppTextRole.input, color: colors.onSurface),
      weekendTextStyle:
          AppTextStyle(AppTextRole.input, color: colors.onSurface),
      disabledTextStyle: AppTextStyle(AppTextRole.input,
          color: colors.onSurface.withValues(alpha: .28)),
      selectedTextStyle: AppTextStyle(AppTextRole.input, color: interactive),
      selectedDecoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: interactive, width: 1.2),
      ),
      todayDecoration: const BoxDecoration(shape: BoxShape.circle),
      todayTextStyle: AppTextStyle(AppTextRole.input, color: interactive),
      cellMargin: const EdgeInsets.all(1),
    );
  }

  static DaysOfWeekStyle daysOfWeek(BuildContext context) {
    final color =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: .55);
    return DaysOfWeekStyle(
      dowTextFormatter: (date, locale) =>
          CalendarLabelFormatter.weekday(date, locale as String?),
      weekdayStyle: AppTextStyle(AppTextRole.caption, color: color),
      weekendStyle: AppTextStyle(AppTextRole.caption, color: color),
    );
  }
}
