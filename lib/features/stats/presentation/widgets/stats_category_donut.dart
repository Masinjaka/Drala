import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'stats_donut_painter.dart';

class StatsCategoryDonut extends StatelessWidget {
  const StatsCategoryDonut(
      {required this.stats, required this.loading, super.key});
  final MonthlyStats stats;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    final colors = stats.expenseCategories
        .map((category) =>
            AppStatsTheme.categoryColor(context, category.colorHex))
        .toList(growable: false);
    final amounts = stats.expenseCategories
        .map((category) => category.amount)
        .toList(growable: false);
    return Container(
        height: 181,
        decoration: BoxDecoration(
            color: AppStatsTheme.surface(context),
            boxShadow: AppStatsTheme.shadows(context),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24), bottom: Radius.circular(10))),
        child: Center(
            child: loading
                ? const ValueSkeleton(width: 142, height: 142)
                : SizedBox.square(
                    dimension: 142,
                    child: Stack(alignment: Alignment.center, children: [
                      TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: MediaQuery.disableAnimationsOf(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) => CustomPaint(
                              key: const Key('stats-category-donut'),
                              size: const Size.square(142),
                              painter: StatsDonutPainter(
                                  colors: colors,
                                  amounts: amounts,
                                  progress: value,
                                  track: AppStatsTheme.ringTrack(context)))),
                      SizedBox(
                          width: 88,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                          stats.expenseChange < 0
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          size: 8,
                                          color: AppStatsTheme.accent(context)),
                                      Text(
                                          AmountVisibilityScope.isVisibleOf(
                                                  context)
                                              ? '${stats.expenseChange >= 0 ? '+' : ''}${stats.expenseChange.toStringAsFixed(2)}%'
                                              : '***',
                                          style: AppStatsTheme.donutValue(
                                              context)),
                                    ])),
                            const SizedBox(height: 2),
                            Text(context.l10n.statsPreviousMonth,
                                textAlign: TextAlign.center,
                                style: AppStatsTheme.donutCaption(context)),
                          ])),
                    ]))));
  }
}
