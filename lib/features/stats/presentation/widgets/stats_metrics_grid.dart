import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class StatsMetricsGrid extends StatelessWidget {
  const StatsMetricsGrid(
      {required this.stats, this.displayCurrency, super.key});

  final MonthlyStats stats;
  final CurrencyState? displayCurrency;

  @override
  Widget build(BuildContext context) {
    final cards = [
      StatsMetricCard(
        label: context.l10n.income,
        value: _compact(stats.income),
        emoji: '🙂',
      ),
      StatsMetricCard(
        label: context.l10n.expenses,
        value: _compact(stats.expenses),
        emoji: '😟',
        valueColor: const Color(0xFFD61F1F),
      ),
      StatsMetricCard(
        key: const Key('stats-transactions-card'),
        label: context.l10n.transactions,
        value: '${stats.transactionCount}',
        emoji: '🔁',
        maskValue: false,
      ),
      StatsMetricCard(
        key: const Key('stats-net-card'),
        label: context.l10n.netThisMonth,
        value: _compact(stats.balance),
        emoji: '🌑',
      ),
    ];
    return Column(
      children: [
        Row(children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 8),
          Expanded(child: cards[1]),
        ]),
        const SizedBox(height: 17),
        Row(children: [
          Expanded(child: cards[2]),
          const SizedBox(width: 8),
          Expanded(child: cards[3]),
        ]),
      ],
    );
  }

  String _compact(int amount) {
    final converted = displayCurrency?.convertToSelected(
          amount,
          stats.currencyCode,
        ) ??
        amount;
    if (converted.abs() >= 1000000) return '${_trim(converted / 1000000)} M';
    if (converted.abs() >= 1000) return '${_trim(converted / 1000)} k';
    return _trim(converted);
  }

  String _trim(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
}
