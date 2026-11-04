import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'stats_amount.dart';
import 'stats_line_chart.dart';

class MonthlySpendingChart extends StatelessWidget {
  const MonthlySpendingChart(
      {required this.values,
      this.loading = false,
      this.average = 0,
      this.currencyCode = 'MGA',
      super.key});
  final List<int> values;
  final bool loading;
  final num average;
  final String currencyCode;
  @override
  Widget build(BuildContext context) => Container(
      height: AppStatsTheme.spendingHeight(context),
      padding: const EdgeInsets.fromLTRB(19, 20, 16, 14),
      decoration: BoxDecoration(
          color: AppStatsTheme.surface(context),
          boxShadow: AppStatsTheme.shadows(context),
          borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(context.l10n.dailySpending, style: AppStatsTheme.label(context)),
        const SizedBox(height: 12),
        Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: StatsAmount(
                          value: average,
                          currencyCode: currencyCode,
                          size: 20,
                          currencySize: 11))),
              const SizedBox(width: 8),
              Text(context.l10n.statsOnAverage,
                  style: AppStatsTheme.caption(context)),
            ]),
        const Spacer(),
        SizedBox(
            height: 138,
            child: loading
                ? const SizedBox.expand(key: Key('stats-chart-empty'))
                : StatsLineChart(values: values)),
      ]));
}
