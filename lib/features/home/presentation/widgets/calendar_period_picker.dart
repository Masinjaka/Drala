import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:flutter/material.dart';

class CalendarPeriodPicker extends StatelessWidget {
  const CalendarPeriodPicker({
    required this.focusedDay,
    required this.onTap,
    super.key,
  });

  final DateTime focusedDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 28,
        child: InkWell(
          key: const Key('calendar-period-picker'),
          onTap: onTap,
          borderRadius: AppButtonTheme.borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CalendarLabelFormatter.monthYear(
                    focusedDay,
                    Localizations.localeOf(context).toLanguageTag(),
                  ),
                  style: AppTextStyle(AppTextRole.body,
                      color: Theme.of(context).colorScheme.inverseSurface),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppIconForeground.resolve(
                    context,
                    Theme.of(context).colorScheme.inverseSurface,
                  ),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
