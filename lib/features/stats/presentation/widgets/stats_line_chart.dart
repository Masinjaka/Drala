import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/features/stats/presentation/widgets/spending_chart_grid.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_line_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsLineChart extends StatelessWidget {
  const StatsLineChart({required this.values, super.key});
  final List<int> values;
  @override
  Widget build(BuildContext context) {
    final label = AppStatsTheme.axis(context);
    final maximum = values.fold<int>(0, (a, b) => a > b ? a : b);
    String tick(num value) => AmountVisibilityScope.isVisibleOf(context)
        ? NumberFormat.compact(
                locale: Localizations.localeOf(context).toLanguageTag())
            .format(value)
        : '***';
    return Column(children: [
      Expanded(
          child: Row(children: [
        Expanded(
            child: CustomPaint(
                painter: SpendingChartGrid(AppStatsTheme.grid(context)),
                child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, progress, _) => CustomPaint(
                        key: const Key('stats-line-chart'),
                        painter: StatsLineChartPainter(
                            values: values,
                            progress: progress,
                            fillGradient: AppStatsTheme.chartFill(context),
                            color: AppStatsTheme.accent(context)),
                        child: const SizedBox.expand())))),
        const SizedBox(width: AppStatsTheme.axisGap),
        SizedBox(
            width: AppStatsTheme.axisWidth(context),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(tick(maximum), maxLines: 1, style: label)),
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child:
                          Text(tick(maximum / 2), maxLines: 1, style: label)),
                  Text('0', maxLines: 1, style: label),
                ])),
      ])),
      const SizedBox(height: 8),
      Padding(
          padding: EdgeInsets.only(
              right: AppStatsTheme.axisWidth(context) + AppStatsTheme.axisGap),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('1', style: label),
            if (values.length > 2)
              Text('${(values.length + 1) ~/ 2}', style: label),
            if (values.length > 1) Text('${values.length}', style: label),
          ])),
    ]);
  }
}
