import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('transaction obfuscation slides smoothly to the right',
      (tester) async {
    final controller = AmountVisibilityController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        builder: (context, child) => AmountVisibilityScope(
          controller: controller,
          child: child ?? const SizedBox.shrink(),
        ),
        home: Scaffold(
          body: HomeOperationRow(
            entry: FinanceEntry(
              id: 'coffee',
              title: 'Coffee',
              categoryName: 'Food',
              amount: 5000,
              occurredAt: DateTime(2026, 10, 2),
              transactionType: 'expense',
              currencyCode: 'MGA',
              iconKey: 'food',
              emoji: '☕',
            ),
            currencyState: null,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final badge =
        find.byKey(const ValueKey('operation-amount-badge-coffee'));
    final initialBadgeWidth = tester.getSize(badge).width;
    controller.toggle();
    await tester.pump();

    final hidden = find.byKey(const ValueKey('hidden-operation-coffee'));
    final startLeft = tester.getTopLeft(hidden).dx;
    await tester.pump(const Duration(milliseconds: 130));
    final middleLeft = tester.getTopLeft(hidden).dx;
    final middleBadgeWidth = tester.getSize(badge).width;
    await tester.pump(const Duration(milliseconds: 130));
    final endLeft = tester.getTopLeft(hidden).dx;
    final endBadgeWidth = tester.getSize(badge).width;
    await tester.pump(const Duration(milliseconds: 16));
    final settledLeft = tester.getTopLeft(hidden).dx;

    expect(middleLeft, greaterThan(startLeft));
    expect(endLeft, greaterThan(middleLeft));
    expect(settledLeft, closeTo(endLeft, .01));
    expect(middleBadgeWidth, lessThan(initialBadgeWidth));
    expect(endBadgeWidth, lessThan(middleBadgeWidth));
    expect(find.text('-5 000 MGA'), findsNothing);
    expect(find.text('***'), findsOneWidget);
  });
}
