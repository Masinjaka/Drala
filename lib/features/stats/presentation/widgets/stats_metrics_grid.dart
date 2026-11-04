import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'stats_metric_card.dart';

class StatsMetricsGrid extends StatelessWidget {
  const StatsMetricsGrid(
      {required this.stats,
      this.displayCurrency,
      this.loading = false,
      super.key});
  final MonthlyStats stats;
  final bool loading;
  final CurrencyState? displayCurrency;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: StatsMetricCard(
                key: const Key('stats-expenses-card'),
                loading: loading,
                label: context.l10n.expenses,
                value: _convert(stats.expenses),
                currencyCode: _code)),
        const SizedBox(width: 14),
        Expanded(
            child: StatsMetricCard(
                key: const Key('stats-income-card'),
                income: true,
                loading: loading,
                label: context.l10n.income,
                value: _convert(stats.income),
                currencyCode: _code)),
      ]);
  num _convert(int value) =>
      displayCurrency?.convertToSelected(value, stats.currencyCode) ?? value;
  String get _code => displayCurrency?.code ?? stats.currencyCode;
}
