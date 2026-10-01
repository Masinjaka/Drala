import 'dart:async';

import 'package:flutter/material.dart';

class HomeWeekPager {
  const HomeWeekPager._();

  static final _firstWeek = weekStart(DateTime(2000));

  static DateTime weekStart(DateTime date) =>
      DateTime(date.year, date.month, date.day - date.weekday % 7);

  static int pageFor(DateTime date) =>
      weekStart(date).difference(_firstWeek).inDays ~/ 7;

  static DateTime dateForPage(int page) =>
      _firstWeek.add(Duration(days: page * 7));

  static void show(PageController controller, DateTime date) {
    if (!controller.hasClients) return;
    final target = pageFor(date);
    final current = controller.page?.round();
    if (current == null || current == target) return;
    if ((target - current).abs() == 1) {
      unawaited(controller.animateToPage(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      ));
    } else {
      controller.jumpToPage(target);
    }
  }
}
