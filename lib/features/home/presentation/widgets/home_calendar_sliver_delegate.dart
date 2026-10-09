import 'package:flutter/material.dart';
import 'package:budgets/core/ui/scroll_edge_gradient.dart';
import 'package:budgets/core/ui/animated_scroll_edge_gradient.dart';
import 'calendar_view_toggle.dart';
import 'home_calendar_top_gap.dart';

class HomeCalendarSliverDelegate extends SliverPersistentHeaderDelegate {
  HomeCalendarSliverDelegate({
    required this.daysHeight,
    required this.compact,
    required this.builder,
    this.onVisibilityChanged,
  });

  final double daysHeight;
  final bool compact;
  final ValueChanged<double>? onVisibilityChanged;
  final Widget Function(Animation<double>) builder;

  static const controlsHeight = 49.0 +
      CalendarViewToggle.height -
      CalendarViewToggle.collapsedSpacing -
      (CalendarViewToggle.collapsedSpacing - HomeCalendarTopGap.expandedHeight);

  @override
  double get minExtent => daysHeight;

  @override
  double get maxExtent => daysHeight + (compact ? 0 : controlsHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final visibility =
        compact ? 0.0 : (1 - shrinkOffset / controlsHeight).clamp(0.0, 1.0);
    onVisibilityChanged?.call(visibility);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 29),
            child: ClipRect(
              child: builder(AlwaysStoppedAnimation(visibility)),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -ScrollEdgeGradient.height,
          child: AnimatedScrollEdgeGradient(
            top: true,
            visible: overlapsContent || shrinkOffset > maxExtent - minExtent,
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant HomeCalendarSliverDelegate oldDelegate) => true;
}
