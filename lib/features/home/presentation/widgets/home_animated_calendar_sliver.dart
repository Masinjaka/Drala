import 'package:flutter/material.dart';
import 'home_calendar_sliver_delegate.dart';

/// Animates the sliver extent itself so the list follows the calendar's size.
class HomeAnimatedCalendarSliver extends StatelessWidget {
  const HomeAnimatedCalendarSliver({
    required this.daysHeight,
    required this.compact,
    required this.builder,
    this.onVisibilityChanged,
    super.key,
  });

  final double daysHeight;
  final bool compact;
  final ValueChanged<double>? onVisibilityChanged;
  final Widget Function(Animation<double>, double) builder;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(end: daysHeight),
        duration: compact || MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        builder: (context, height, _) => SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: HomeCalendarSliverDelegate(
            daysHeight: height,
            compact: compact,
            onVisibilityChanged: onVisibilityChanged,
            builder: (visibility) => builder(visibility, height),
          ),
        ),
      );
}
