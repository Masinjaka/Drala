import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/scroll_edge_fade.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metrics_grid.dart';
import 'package:budgets/features/stats/presentation/widgets/monthly_spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatsMonthPage extends StatelessWidget {
  const StatsMonthPage(
      {required this.stats,
      required this.loading,
      required this.onRefresh,
      this.displayCurrency,
      super.key});
  final MonthlyStats? stats;
  final bool loading;
  final Future<void> Function() onRefresh;
  final CurrencyState? displayCurrency;
  static const _empty = MonthlyStats(
      income: 0,
      expenses: 0,
      transactionCount: 0,
      largestExpense: 0,
      previousExpenses: 0,
      expenseCategories: [],
      dailyExpenses: [],
      currencyCode: 'MGA');

  @override
  Widget build(BuildContext context) => ScrollEdgeFade(
      child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
              padding: const EdgeInsets.fromLTRB(29, 0, 29, 32),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _animateLoadedContent(StatsMetricsGrid(
                    stats: stats ?? _empty,
                    loading: loading,
                    displayCurrency: displayCurrency)),
                const SizedBox(height: 17),
                _animateLoadedContent(MonthlySpendingChart(
                    values: stats?.dailyExpenses ?? [], loading: loading)),
              ])));

  Widget _animateLoadedContent(Widget child) {
    if (loading) return child;
    return child
        .animate()
        .fadeIn(duration: 200.ms)
        .slideY(begin: .15, duration: 200.ms, curve: Curves.easeOut);
  }
}
