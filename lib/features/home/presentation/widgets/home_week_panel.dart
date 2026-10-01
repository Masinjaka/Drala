import 'dart:async';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/features/home/presentation/view_models/activity_calendar_view_model.dart';
import 'package:budgets/features/home/presentation/widgets/calendar_view_toggle.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_header.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_top_gap.dart';
import 'package:budgets/features/home/presentation/widgets/home_month_calendar.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_strip.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_pager.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_transition.dart';
import 'package:budgets/features/home/presentation/widgets/home_scroll_reveal.dart';
import 'package:budgets/features/home/presentation/widgets/home_animated_calendar_sliver.dart';
import 'package:budgets/features/home/presentation/widgets/home_calendar_transition.dart';
import 'package:flutter/material.dart';
class HomeWeekPanel extends StatefulWidget {
  const HomeWeekPanel(
      {required this.today,
      required this.selectedDate,
      required this.onDateSelected,
      this.activityViewModel,
      this.compact = false,
      this.onControlsVisibilityChanged,
      super.key});
  final DateTime today;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final ActivityCalendarViewModel? activityViewModel;
  final bool compact;
  final ValueChanged<double>? onControlsVisibilityChanged;
  @override
  State<HomeWeekPanel> createState() => _HomeWeekPanelState();
}
class _HomeWeekPanelState extends State<HomeWeekPanel> {
  late DateTime _focusedDay;
  late final PageController _weekController;
  bool _expanded = false;
  DateTime get _today => DateUtils.dateOnly(widget.today);
  DateTime get _start => DateTime(_focusedDay.year, _focusedDay.month,
      _focusedDay.day - _focusedDay.weekday % 7);
  @override
  void initState() {
    super.initState();
    _focusedDay = DateUtils.dateOnly(widget.selectedDate);
    _weekController = PageController(
      initialPage: HomeWeekPager.pageFor(_focusedDay),
    );
    _loadActivity();
  }
  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(covariant HomeWeekPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _focusedDay = DateUtils.dateOnly(widget.selectedDate);
    }
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.compact != widget.compact ||
        oldWidget.activityViewModel != widget.activityViewModel) {
      _loadActivity();
    }
  }
  void _loadActivity() {
    final model = widget.activityViewModel;
    if (model == null) return;
    unawaited(model.loadMonth(_focusedDay));
    if (!_expanded || widget.compact) {
      if (_start.month != _focusedDay.month) unawaited(model.loadMonth(_start));
      final end = DateTime(_start.year, _start.month, _start.day + 6);
      if (end.month != _focusedDay.month) unawaited(model.loadMonth(end));
    }
  }
  void _focus(DateTime date) {
    final bounded = date.isBefore(DateTime(2000))
        ? DateTime(2000)
        : date.isAfter(_today)
            ? _today
            : date;
    setState(() => _focusedDay = bounded);
    HomeWeekPager.show(_weekController, bounded);
    _loadActivity();
  }
  DateTime _adjacent(int direction) => _expanded
      ? DateTime(_focusedDay.year, _focusedDay.month + direction)
      : DateTime(
          _focusedDay.year, _focusedDay.month, _focusedDay.day + 7 * direction);
  Future<void> _selectPeriod() async {
    final date = await AppWheelPicker.monthYear(context,
        initialDate: _focusedDay,
        firstDate: DateTime(2000),
        lastDate: _today,
        title: MaterialLocalizations.of(context).datePickerHelpText);
    if (date != null && mounted) _focus(DateTime(date.year, date.month));
  }
  void _selectDay(DateTime date) {
    _focus(date);
    widget.onDateSelected(date);
  }
  @override
  Widget build(BuildContext context) {
    final model = widget.activityViewModel;
    return model == null
        ? _sliver(context)
        : ListenableBuilder(
            listenable: model, builder: (context, _) => _sliver(context));
  }
  Widget _sliver(BuildContext context) {
    final calendarHeight = _expanded && !widget.compact
        ? HomeMonthCalendar.heightFor(_focusedDay)
        : HomeWeekStrip.heightFor(context);
    final collapsedGap = CalendarViewToggle.collapsedSpacing;
    final daysHeight = calendarHeight + collapsedGap * 2;
    return HomeAnimatedCalendarSliver(
      daysHeight: daysHeight,
      compact: widget.compact,
      onVisibilityChanged: widget.onControlsVisibilityChanged,
      builder: (visibility, height) =>
          _panel(context, visibility, height - collapsedGap * 2),
    );
  }

  Widget _panel(
      BuildContext context, Animation<double> visibility, double height) {
    final next = _expanded
        ? _adjacent(1)
        : DateTime(_start.year, _start.month, _start.day + 7);
    final canGoBack = _expanded
        ? DateTime(_focusedDay.year, _focusedDay.month).isAfter(DateTime(2000))
        : _start.isAfter(DateTime(2000));
    final activity =
        widget.activityViewModel?.activityDates ?? const <DateTime>{};
    return Container(
      key: const Key('home-week-panel'),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF4F4F4)
            : Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        HomeScrollReveal(
          key: const Key('home-calendar-header-reveal'),
          visibility: visibility,
          child: HomeCalendarHeader(
            focusedDay: _focusedDay,
            onPeriodPressed: _selectPeriod,
            onPrevious: canGoBack ? () => _focus(_adjacent(-1)) : null,
            onNext: next.isAfter(_today) ? null : () => _focus(_adjacent(1)),
          ),
        ),
        HomeCalendarTopGap(
          visibility: visibility,
          height: CalendarViewToggle.collapsedSpacing,
        ),
        HomeCalendarTransition(
          height: height,
          compact: widget.compact,
          child: _expanded && !widget.compact
              ? HomeMonthCalendar(
                  focusedDay: _focusedDay,
                  selectedDay: widget.selectedDate,
                  today: _today,
                  activityDates: activity,
                  onDaySelected: _selectDay,
                  onPageChanged: _focus)
              : HomeWeekTransition(
                  pageController: _weekController,
                  focusedDate: _focusedDay,
                  selectedDate: widget.selectedDate,
                  today: _today,
                  onDateSelected: _selectDay,
                  activityDates: activity,
                  onPreviousWeek:
                      canGoBack ? () => _focus(_adjacent(-1)) : null,
                  onNextWeek:
                      next.isAfter(_today) ? null : () => _focus(_adjacent(1)),
                ),
        ),
        HomeScrollReveal(
          key: const Key('home-calendar-toggle-reveal'),
          visibility: visibility,
          alignment: 1,
          minimumSizeFactor:
              CalendarViewToggle.collapsedSpacing / CalendarViewToggle.height,
          child: CalendarViewToggle(
            isExpanded: _expanded,
            onPressed: () {
              setState(() => _expanded = !_expanded);
              _loadActivity();
            },
          ),
        ),
      ]),
    );
  }
}
