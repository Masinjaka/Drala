import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('currency amounts use the app numeric font and full values',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
            body: StatsMetricCard(
                label: 'Income', value: 150000, currencyCode: 'MGA'))));
    await tester.pumpAndSettle();
    final counter = tester
        .widget<AnimatedCompactAmount>(find.byType(AnimatedCompactAmount));
    expect(counter.style.fontFamily, AppTypography.amountFontFamily);
    expect(counter.value, 150000);
    expect(counter.compact, isFalse);
    expect(find.text('Ar'), findsOneWidget);
  });
}
