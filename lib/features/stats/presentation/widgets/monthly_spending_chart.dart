import 'package:budgets/features/stats/presentation/widgets/spending_chart_grid.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_line_chart.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class MonthlySpendingChart extends StatelessWidget {
  const MonthlySpendingChart(
      {required this.values, this.loading = false, super.key});

  final List<int> values;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      padding: const EdgeInsets.fromLTRB(24, 27, 13, 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dailySpending,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
          Expanded(
            child: CustomPaint(
              painter: SpendingChartGrid(Theme.of(context).colorScheme.outline),
              child: loading
                  ? const SizedBox.expand(
                      key: Key('stats-chart-empty'),
                    )
                  : StatsLineChart(values: values),
            ),
          ),
        ],
      ),
    );
  }
}
