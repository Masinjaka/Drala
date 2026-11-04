import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_view_toggle.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_top_gap.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_transition.dart';
import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:budgets/features/home/presentation/widgets/home_scroll_reveal.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_transition.dart';
import 'package:flutter/material.dart';

class HomeCalendarPanel extends StatelessWidget {
  const HomeCalendarPanel(
      {required this.focusedDay,
      required this.selectedDay,
      required this.today,
      required this.activityDates,
      required this.expanded,
      required this.compact,
      required this.activitiesStyle,
      required this.visibility,
      required this.height,
      required this.onPeriodPressed,
      required this.onPrevious,
      required this.onNext,
      required this.onDaySelected,
      required this.onFocus,
      required this.onToggle,
      super.key});
  final DateTime focusedDay;
  final DateTime selectedDay;
  final DateTime today;
  final Set<DateTime> activityDates;
  final bool expanded;
  final bool compact;
  final bool activitiesStyle;
  final Animation<double> visibility;
  final double height;
  final VoidCallback onPeriodPressed;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onFocus;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final content = Column(mainAxisSize: MainAxisSize.min, children: [
      HomeScrollReveal(
          key: const Key('home-calendar-header-reveal'),
          visibility: visibility,
          child: HomeCalendarHeader(
              focusedDay: focusedDay,
              onPeriodPressed: onPeriodPressed,
              onPrevious: onPrevious,
              onNext: onNext,
              compact: activitiesStyle)),
      HomeCalendarTopGap(
          visibility: visibility, height: CalendarViewToggle.collapsedSpacing),
      HomeCalendarTransition(
          height: height,
          compact: compact,
          child: expanded && !compact
              ? HomeMonthCalendar(
                  focusedDay: focusedDay,
                  selectedDay: selectedDay,
                  today: today,
                  activityDates: activityDates,
                  filledSelection: activitiesStyle,
                  onDaySelected: onDaySelected,
                  onPageChanged: onFocus)
              : HomeWeekTransition(
                  focusedDate: focusedDay,
                  selectedDate: selectedDay,
                  today: today,
                  onDateSelected: onDaySelected,
                  activityDates: activityDates,
                  filledSelection: activitiesStyle,
                  onPreviousWeek: onPrevious,
                  onNextWeek: onNext)),
      HomeScrollReveal(
          key: const Key('home-calendar-toggle-reveal'),
          visibility: visibility,
          alignment: 1,
          minimumSizeFactor:
              CalendarViewToggle.collapsedSpacing / CalendarViewToggle.height,
          child: CalendarViewToggle(isExpanded: expanded, onPressed: onToggle)),
    ]);
    return Theme(
      data: AppInteractionTheme.withoutInkFeedback(context),
      child: activitiesStyle
          ? AppCardSurface(
              key: const Key('home-week-panel'),
              color: AppActivitiesTheme.card(context),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: content))
          : Container(
              key: const Key('home-week-panel'),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10)),
              child: content),
    );
  }
}
