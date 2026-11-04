import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:flutter/material.dart';

class CalendarSelectionIndicator extends StatelessWidget {
  const CalendarSelectionIndicator({required this.bounds, super.key});
  final Rect bounds;

  @override
  Widget build(BuildContext context) => AnimatedPositionedDirectional(
        start: bounds.left,
        top: bounds.top,
        width: bounds.width,
        height: bounds.height,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppActivitiesTheme.calendarSelectionDuration,
        curve: Curves.easeInOutCubic,
        child: IgnorePointer(
            child: ExcludeSemantics(
                child: DecoratedBox(
          key: const Key('calendar-selection-highlight'),
          decoration: BoxDecoration(
              color: AppActivitiesTheme.selectedDay(context),
              borderRadius: BorderRadius.circular(10)),
        ))),
      );
}
