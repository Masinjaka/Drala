import 'package:budgets/features/home/presentation/widgets/calendar_label_formatter.dart';
import 'package:flutter/material.dart';

class HomeCalendarHeader extends StatelessWidget {
  const HomeCalendarHeader({
    required this.focusedDay,
    required this.onPeriodPressed,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime focusedDay;
  final VoidCallback onPeriodPressed;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 49,
        child: Row(children: [
          Expanded(
            child: InkWell(
              key: const Key('calendar-period-picker'),
              onTap: onPeriodPressed,
              borderRadius: BorderRadius.circular(8),
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
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('home-previous-week'),
            tooltip: MaterialLocalizations.of(context).previousPageTooltip,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            onPressed: onPrevious,
          ),
          IconButton(
            key: const Key('home-next-week'),
            tooltip: MaterialLocalizations.of(context).nextPageTooltip,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: onNext,
          ),
        ]),
      );
}
