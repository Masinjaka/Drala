import 'package:budgets/core/layout/app_page_spacing.dart';
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
    return SizedBox.expand(
        child: ColoredBox(
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
    ));
  }

  @override
  bool shouldRebuild(covariant HomeCalendarSliverDelegate oldDelegate) => true;
}
