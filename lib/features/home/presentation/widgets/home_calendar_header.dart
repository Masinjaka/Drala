import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';

class HomeCalendarHeader extends StatelessWidget {
  const HomeCalendarHeader({
    required this.focusedDay,
    required this.onPeriodPressed,
    required this.onPrevious,
    required this.onNext,
    this.compact = false,
    super.key,
  });

  final DateTime focusedDay;
  final VoidCallback onPeriodPressed;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: compact ? 44 : 49,
        child: Row(children: [
          Expanded(
            child: InkWell(
              key: const Key('calendar-period-picker'),
              onTap: onPeriodPressed,
              borderRadius: AppButtonTheme.borderRadius,
              child: SizedBox(
                height: 44,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    child: Text(
                      CalendarLabelFormatter.monthYear(
                        focusedDay,
                        Localizations.localeOf(context).toLanguageTag(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: compact
                          ? AppActivitiesTheme.label(context)
                          : const AppTextStyle(AppTextRole.body),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('home-previous-week'),
            constraints: compact
                ? const BoxConstraints.tightFor(width: 36, height: 44)
                : null,
            padding: compact ? EdgeInsets.zero : const EdgeInsets.all(8),
            style: compact
                ? AppInteractionTheme.withoutPressFeedback(IconButton.styleFrom(
                    fixedSize: const Size(36, 44),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap))
                : null,
            tooltip: MaterialLocalizations.of(context).previousPageTooltip,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            onPressed: onPrevious,
          ),
          IconButton(
            key: const Key('home-next-week'),
            constraints: compact
                ? const BoxConstraints.tightFor(width: 36, height: 44)
                : null,
            padding: compact ? EdgeInsets.zero : const EdgeInsets.all(8),
            style: compact
                ? AppInteractionTheme.withoutPressFeedback(IconButton.styleFrom(
                    fixedSize: const Size(36, 44),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap))
                : null,
            tooltip: MaterialLocalizations.of(context).nextPageTooltip,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: onNext,
          ),
        ]),
      );
}
