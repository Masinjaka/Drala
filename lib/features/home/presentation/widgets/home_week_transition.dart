import 'package:budgets/features/home/presentation/widgets/home_week_pager.dart';
import 'package:budgets/features/home/presentation/widgets/home_week_strip.dart';
import 'package:flutter/material.dart';

class HomeWeekTransition extends StatefulWidget {
  const HomeWeekTransition({
    required this.focusedDate,
    required this.selectedDate,
    required this.today,
    required this.onDateSelected,
    required this.activityDates,
    required this.onPreviousWeek,
    required this.onNextWeek,
    this.pageController,
    super.key,
  });

  final DateTime focusedDate;
  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onDateSelected;
  final Set<DateTime> activityDates;
  final VoidCallback? onPreviousWeek;
  final VoidCallback? onNextWeek;
  final PageController? pageController;

  @override
  State<HomeWeekTransition> createState() => _HomeWeekTransitionState();
}

class _HomeWeekTransitionState extends State<HomeWeekTransition> {
  late final PageController _controller;
  int? _reportedPage;
  int? _controllerTarget;

  @override
  void initState() {
    super.initState();
    _controller = widget.pageController ??
        PageController(initialPage: HomeWeekPager.pageFor(widget.focusedDate));
  }

  @override
  void didUpdateWidget(covariant HomeWeekTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pageController != null) return;
    final target = HomeWeekPager.pageFor(widget.focusedDate);
    if (_reportedPage == target) {
      _reportedPage = null;
      return;
    }
    if (!_controller.hasClients || _controller.page?.round() == target) return;
    _controllerTarget = target;
    final previous = HomeWeekPager.pageFor(oldWidget.focusedDate);
    if ((target - previous).abs() == 1) {
      _controller.animateToPage(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _controller.jumpToPage(target);
    }
  }

  @override
  void dispose() {
    if (widget.pageController == null) _controller.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    final target = _controllerTarget;
    if (target != null) {
      if (page == target) _controllerTarget = null;
      return;
    }
    final current = HomeWeekPager.pageFor(widget.focusedDate);
    if (page == current) return;
    _reportedPage = page;
    if (page > current) {
      widget.onNextWeek?.call();
    } else {
      widget.onPreviousWeek?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = HomeWeekPager.pageFor(widget.today) + 1;
    return SizedBox(
      height: HomeWeekStrip.heightFor(context),
      child: PageView.builder(
        key: const Key('home-week-swipe-surface'),
        controller: _controller,
        physics: const PageScrollPhysics(),
        itemCount: pageCount,
        onPageChanged: _handlePageChanged,
        itemBuilder: (context, page) => HomeWeekStrip(
          key: ValueKey(HomeWeekPager.dateForPage(page)),
          focusedDate: HomeWeekPager.dateForPage(page),
          selectedDate: widget.selectedDate,
          today: widget.today,
          onDateSelected: widget.onDateSelected,
          activityDates: widget.activityDates,
        ),
      ),
    );
  }
}
