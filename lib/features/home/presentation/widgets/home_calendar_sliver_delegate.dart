import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_glass_backdrop.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'calendar_view_toggle.dart';
import 'home_calendar_top_gap.dart';

class HomeCalendarSliverDelegate extends SliverPersistentHeaderDelegate {
  HomeCalendarSliverDelegate({
    required this.daysHeight,
    required this.compact,
    required this.builder,
    this.onVisibilityChanged,
    this.activitiesStyle = false,
  });

  final double daysHeight;
  final bool compact;
  final bool activitiesStyle;
  final ValueChanged<double>? onVisibilityChanged;
  final Widget Function(Animation<double>) builder;

  static const controlsHeight = 49.0 +
      CalendarViewToggle.height -
      CalendarViewToggle.collapsedSpacing -
      (CalendarViewToggle.collapsedSpacing - HomeCalendarTopGap.expandedHeight);

  double get _controlsExtent => controlsHeight - (activitiesStyle ? 5 : 0);
  double get _pinnedGap =>
      activitiesStyle ? AppActivitiesTheme.calendarPinnedBottomGap : 0;
  double get _collapseExtent => _controlsExtent - _pinnedGap;

  @override
  double get minExtent => daysHeight + _pinnedGap;

  @override
  double get maxExtent => compact ? minExtent : daysHeight + _controlsExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final visibility =
        compact ? 0.0 : (1 - shrinkOffset / _collapseExtent).clamp(0.0, 1.0);
    onVisibilityChanged?.call(visibility);
    final calendar = ColoredBox(
      key: const Key('calendar-pinned-background'),
      color: activitiesStyle
          ? AppActivitiesTheme.background(context)
          : Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: AppPageSpacing.insets(context,
            bottom: _pinnedGap * (1 - visibility)),
        child: ClipRect(
          clipBehavior: activitiesStyle ? Clip.none : Clip.hardEdge,
          child: builder(AlwaysStoppedAnimation(visibility)),
        ),
      ),
    );
    if (!activitiesStyle) return SizedBox.expand(child: calendar);
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        // Painted below the calendar so the card shadow blends into the fade
        // instead of being cut off by its opaque top edge.
        if (visibility == 0 && shrinkOffset >= _collapseExtent)
          const Positioned(
            left: 0,
            right: 0,
            bottom: -AppHeaderMetrics.buttonSize,
            height: AppHeaderMetrics.buttonSize,
            child: IgnorePointer(
              child: AppGlassBackdrop(
                key: Key('activities-calendar-scroll-fade'),
                top: false,
                amount: 1,
              ),
            ),
          ),
        calendar,
      ],
    );
  }

  @override
  bool shouldRebuild(covariant HomeCalendarSliverDelegate oldDelegate) => true;
}
