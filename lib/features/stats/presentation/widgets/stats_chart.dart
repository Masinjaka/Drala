import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'stats_chart_layout.dart';
part 'stats_chart_period_selector.dart';

class StatsChart extends ConsumerStatefulWidget {
  final List<double> expenseData;
  final List<double> incomeData;
  final int daysInMonth;
  final DateTime selectedMonth;

  const StatsChart({
    super.key,
    required this.expenseData,
    required this.incomeData,
    required this.daysInMonth,
    required this.selectedMonth,
  });

  @override
  ConsumerState<StatsChart> createState() => _StatsChartState();
}

class _StatsChartState extends ConsumerState<StatsChart> {
  late int _selectedWeekIndex;

  int get _totalWeeks => ((widget.daysInMonth - 1) ~/ 7) + 1;

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return now.year == widget.selectedMonth.year &&
        now.month == widget.selectedMonth.month;
  }

  int get _currentWeekIndex {
    if (!_isCurrentMonth) return 0;
    return (DateTime.now().day - 1) ~/ 7;
  }

  // 0-indexed day range for a given week
  int _weekStartDay(int weekIndex) => weekIndex * 7;
  int _weekEndDay(int weekIndex) =>
      ((weekIndex + 1) * 7 - 1).clamp(0, widget.daysInMonth - 1);

  String _rangeLabel(int weekIndex) {
    final start = weekIndex * 7 + 1;
    final end = ((weekIndex + 1) * 7).clamp(1, widget.daysInMonth);
    return '$start–$end';
  }

  List<int> get _dropdownWeeks {
    if (!_isCurrentMonth) {
      return List.generate(_totalWeeks, (i) => i);
    }
    final weeks = <int>[];
    for (final offset in [-1, 0]) {
      final w = _currentWeekIndex + offset;
      if (w >= 0 && w < _totalWeeks) weeks.add(w);
    }
    return weeks;
  }

  String _weekLabel(int weekIndex) {
    if (!_isCurrentMonth) return _rangeLabel(weekIndex);
    switch (weekIndex - _currentWeekIndex) {
      case -1:
        return 'Semaine passée';
      case 0:
        return 'Cette semaine';
      default:
        return _rangeLabel(weekIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedWeekIndex = _currentWeekIndex;
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);
  void _update(VoidCallback action) => setState(action);
}
