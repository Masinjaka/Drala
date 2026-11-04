import 'package:budgets/core/ui/month_carousel.dart';
import 'package:flutter/material.dart';

class EnvelopeMonthControls extends StatelessWidget {
  const EnvelopeMonthControls(
      {required this.month,
      required this.onChanged,
      required this.canGoNext,
      super.key});
  final DateTime month;
  final ValueChanged<int> onChanged;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsetsDirectional.only(start: 7),
      child: MonthCarousel(
          month: month,
          onChanged: onChanged,
          canGoNext: canGoNext,
          pillStyle: true));
}
