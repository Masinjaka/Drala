import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/stats/presentation/widgets/stats_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('privacy hides money but preserves transaction counts',
      (tester) async {
    final controller = AmountVisibilityController()..toggle();
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(
        home: AmountVisibilityScope(
            controller: controller,
            child: const Scaffold(
                body: Column(children: [
              StatsMetricCard(label: 'Income', value: 500, emoji: '🙂'),
              StatsMetricCard(
                  label: 'Transactions',
                  value: 6,
                  emoji: '🔁',
                  maskValue: false),
            ])))));
    await tester.pumpAndSettle();
    expect(find.text('***'), findsOneWidget);
    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('***'), findsNothing);
  });
}
