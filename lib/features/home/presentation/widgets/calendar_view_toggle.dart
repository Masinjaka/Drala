import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:flutter/material.dart';

class CalendarViewToggle extends StatelessWidget {
  const CalendarViewToggle({
    required this.isExpanded,
    required this.onPressed,
    super.key,
  });

  final bool isExpanded;
  final VoidCallback onPressed;
  static const double height = 32;
  static const double collapsedSpacing = 8;

  @override
  Widget build(BuildContext context) {
    final label = isExpanded ? 'Show week' : 'Show month';
    final animationDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260);
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          key: const Key('calendar-view-toggle'),
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Center(
              child: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: animationDuration,
                curve: Curves.easeInOutCubic,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppControlMetrics.iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
