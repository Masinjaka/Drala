import 'package:budgets/core/widgets/delayed_skeleton.dart';
import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'stats_net_summary.dart';
import 'stats_tab_switcher.dart';
import 'stats_metrics_grid.dart';
import 'monthly_spending_chart.dart';
import 'stats_category_donut.dart';
import 'category_spending_list.dart';

class StatsMonthPage extends StatelessWidget {
  const StatsMonthPage(
      {required this.stats,
      required this.loading,
      required this.onRefresh,
      required this.categories,
      required this.onTabChanged,
      this.displayCurrency,
      this.amountKey,
      super.key});
  final Key? amountKey;
  final MonthlyStats? stats;
  final bool loading;
  final Future<void> Function() onRefresh;
  final bool categories;
  final ValueChanged<bool> onTabChanged;
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
  Widget build(BuildContext context) => DelayedSkeleton(
        pending: loading && stats == null,
        builder: _buildContent,
      );

  Widget _buildContent(BuildContext context, bool showSkeleton) {
    final data = stats ?? _empty;
    num convert(num value) =>
        displayCurrency?.convertToSelected(value, data.currencyCode) ?? value;
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
            key: const Key('stats-content-scroll'),
            primary: true,
            padding: AppScrollPadding.insets(context, top: 0, bottom: 32),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              StatsNetSummary(
                  amountKey: amountKey,
                  stats: data,
                  loading: showSkeleton,
                  available: stats != null,
                  currency: displayCurrency),
              const SizedBox(height: 25),
              Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: StatsTabSwitcher(
                      categories: categories, onChanged: onTabChanged)),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 220),
                  layoutBuilder: (child, previous) => Stack(
                      alignment: Alignment.topCenter,
                      children: [...previous, if (child != null) child]),
                  child: categories
                      ? Column(
                          key: const Key('stats-categories-content'),
                          children: [
                              const SizedBox(height: 1),
                              if (stats != null || showSkeleton)
                                _animate(
                                    context,
                                    StatsCategoryDonut(
                                        stats: data, loading: showSkeleton)),
                              const SizedBox(height: 4),
                              if (stats != null)
                                _animate(
                                    context,
                                    CategorySpendingList(
                                        categories: data.expenseCategories,
                                        total: data.expenses,
                                        currencyCode: data.currencyCode,
                                        displayCurrency: displayCurrency)),
                            ])
                      : Column(
                          key: const Key('stats-numbers-content'),
                          children: [
                              _animate(
                                  context,
                                  StatsMetricsGrid(
                                      stats: data,
                                      loading: showSkeleton,
                                      available: stats != null,
                                      displayCurrency: displayCurrency)),
                              const SizedBox(height: 16),
                              _animate(
                                  context,
                                  MonthlySpendingChart(
                                      values: data.dailyExpenses
                                          .map((v) => convert(v).round())
                                          .toList(),
                                      average: convert(data.averageDailySpend),
                                      currencyCode: displayCurrency?.code ??
                                          data.currencyCode,
                                      loading: stats == null)),
                            ])),
            ]));
  }

  Widget _animate(BuildContext context, Widget child) =>
      stats == null || MediaQuery.disableAnimationsOf(context)
          ? child
          : child
              .animate()
              .fadeIn(duration: 200.ms)
              .slideY(begin: .15, duration: 200.ms, curve: Curves.easeOut);
}
