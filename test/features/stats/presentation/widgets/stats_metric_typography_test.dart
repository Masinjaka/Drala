import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses amount typography only for monetary metrics', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Column(
          children: [
            StatsMetricCard(label: 'Transactions', value: 6, emoji: ''),
            StatsMetricCard(
              label: 'Income',
              value: 500000,
              emoji: '',
              currencyCode: 'MGA',
            ),
          ],
        ),
      ),
    );

    final counters = tester.widgetList<AnimatedCompactAmount>(
      find.byType(AnimatedCompactAmount),
    );
    expect(counters.map((counter) => counter.amountTypography), [false, true]);
    await tester.pump(const Duration(seconds: 1));
  });
}
