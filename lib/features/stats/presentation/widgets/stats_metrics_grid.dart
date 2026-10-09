import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final cards = [
      StatsMetricCard(
        loading: loading,
        label: context.l10n.income,
        value: _convert(stats.income),
        currencyCode: _displayCurrencyCode,
        emoji: '🙂',
      ),
      StatsMetricCard(
        loading: loading,
        label: context.l10n.expenses,
        value: _convert(stats.expenses),
        currencyCode: _displayCurrencyCode,
        emoji: '😟',
        valueColor: Theme.of(context).colorScheme.error,
      ),
      StatsMetricCard(
        key: const Key('stats-transactions-card'),
        maskValue: false,
        loading: loading,
        label: context.l10n.transactions,
        value: stats.transactionCount,
        emoji: '🔁',
      ),
      StatsMetricCard(
        key: const Key('stats-net-card'),
        loading: loading,
        label: context.l10n.netThisMonth,
        value: _convert(stats.balance),
        currencyCode: _displayCurrencyCode,
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

  num _convert(int amount) =>
      displayCurrency?.convertToSelected(amount, stats.currencyCode) ?? amount;

  String get _displayCurrencyCode =>
      displayCurrency?.code ?? stats.currencyCode;
}
