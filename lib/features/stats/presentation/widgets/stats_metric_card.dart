import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:flutter/material.dart';
import 'stats_amount.dart';

class StatsMetricCard extends StatelessWidget {
  const StatsMetricCard(
      {required this.label,
      required this.value,
      this.emoji = '',
      this.income = false,
      this.valueColor,
      this.loading = false,
      this.available = true,
      this.currencyCode,
      this.maskValue = true,
      super.key});
  final String label;
  final num value;
  final String emoji;
  final bool income;
  final Color? valueColor;
  final bool loading;
  final bool available;
  final bool maskValue;
  final String? currencyCode;
  @override
  Widget build(BuildContext context) => Container(
      height: AppStatsTheme.metricHeight(context),
      padding: const EdgeInsets.fromLTRB(21, 18, 21, 20),
      decoration: BoxDecoration(
          color: AppStatsTheme.surface(context),
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppStatsTheme.shadows(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox.square(
            dimension: 32,
            child: Icon(
                income
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: AppStatsTheme.flowIconSize,
                color: AppStatsTheme.flowIconColor(context, income: income))),
        const Spacer(),
        Text(label, style: AppStatsTheme.metricLabel(context)),
        const SizedBox(height: 6),
        if (loading)
          const ValueSkeleton(
              key: Key('stats-value-skeleton'), height: 26, width: 100)
        else if (available)
          FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: StatsAmount(
                  value: value,
                  currencyCode: currencyCode,
                  maskValue: maskValue)),
      ]));
}
