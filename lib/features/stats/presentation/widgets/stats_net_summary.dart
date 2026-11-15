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
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: AppStatsTheme.background(context),
              borderRadius: BorderRadius.circular(50),
              boxShadow: AppStatsTheme.shadows(context)),
          child:
              Text(context.l10n.statsNet, style: AppStatsTheme.label(context)),
        )),
        // Text(context.l10n.statsNetDescription,
        //     style: AppStatsTheme.caption(context)),
        const SizedBox(height: 10),
        SizedBox(
            height: 50,
            child: Align(
                alignment: AlignmentDirectional.center,
                child: loading
                    ? const ValueSkeleton(
                        key: Key('stats-net-skeleton'), width: 168, height: 30)
                    : !available
                        ? null
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: StatsAmount(
                                key: amountKey,
                                value: currency?.convertToSelected(
                                        stats.balance, stats.currencyCode) ??
                                    stats.balance,
                                currencyCode:
                                    currency?.code ?? stats.currencyCode,
                                style: AppHomeOverviewTheme.balance(context),
                                size: AppTypography.balance,
                                currencySize: AppTypography.balance)))),
      ]);
}
