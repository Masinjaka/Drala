import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'stats_amount.dart';

class StatsNetSummary extends StatelessWidget {
  const StatsNetSummary(
      {required this.stats,
      required this.loading,
      this.available = true,
      this.currency,
      this.amountKey,
      super.key});
  final Key? amountKey;
  final MonthlyStats stats;
  final bool loading;
  final bool available;
  final CurrencyState? currency;
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 50,
      child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (loading)
                      const ValueSkeleton(
                          key: Key('stats-net-skeleton'),
                          width: 168,
                          height: 30)
                    else if (available)
                      StatsAmount(
                          key: amountKey,
                          value: currency?.convertToSelected(
                                  stats.balance, stats.currencyCode) ??
                              stats.balance,
                          currencyCode: currency?.code ?? stats.currencyCode,
                          style: AppHomeOverviewTheme.balance(context),
                          size: AppTypography.balance,
                          currencySize: AppTypography.balance),
                    if (loading || available) const SizedBox(width: 8),
                    Text(context.l10n.statsNet,
                        style: AppStatsTheme.label(context)),
                  ]))));
}
