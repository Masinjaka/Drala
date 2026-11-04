import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'stats_amount.dart';

class StatsCategoryRow extends StatelessWidget {
  const StatsCategoryRow(
      {required this.category,
      required this.value,
      required this.total,
      required this.currencyCode,
      this.last = false,
      super.key});
  final CategoryStat category;
  final num value;
  final int total;
  final String currencyCode;
  final bool last;
  @override
  Widget build(BuildContext context) {
    final percentageBackground = AppStatsTheme.background(context);
    return Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
        decoration: BoxDecoration(
            color: AppStatsTheme.surface(context),
            boxShadow: AppStatsTheme.shadows(context),
            borderRadius: BorderRadius.vertical(
                top: const Radius.circular(10),
                bottom: Radius.circular(last ? 24 : 10))),
        child: Row(children: [
          Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              child: CategoryIcon(
                iconKey: category.iconKey,
                emoji: category.emoji,
                colorHex: category.colorHex,
                size: 20,
              )),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStatsTheme.label(context)),
                const SizedBox(height: 6),
                Text(context.l10n.statsActivityCount(category.transactionCount),
                    style: AppStatsTheme.caption(context)),
              ])),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: StatsAmount(
                    value: value,
                    currencyCode: currencyCode,
                    emphasize: false,
                    size: 11,
                    currencySize: 11,
                    sign: '-')),
            const SizedBox(height: 6),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: percentageBackground,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                    AmountVisibilityScope.isVisibleOf(context)
                        ? '${total == 0 ? 0 : (category.amount / total * 100).round()}%'
                        : '***',
                    style: AppStatsTheme.percentage(
                        context, percentageBackground))),
          ])),
        ]));
  }
}
