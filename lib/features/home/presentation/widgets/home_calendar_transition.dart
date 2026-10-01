import 'package:flutter/material.dart';

class HomeCalendarTransition extends StatelessWidget {
  const HomeCalendarTransition({
    required this.height,
    required this.child,
    required this.compact,
    super.key,
  });

  final double height;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: 0,
            maxHeight: height > 264 ? height : 264,
            child: AnimatedSwitcher(
              duration: compact || MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 260),
              switchInCurve: Curves.easeInOutCubic,
              switchOutCurve: Curves.easeInOutCubic,
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, if (current != null) current],
              ),
              child: child,
            ),
          ),
        ),
      );
}
