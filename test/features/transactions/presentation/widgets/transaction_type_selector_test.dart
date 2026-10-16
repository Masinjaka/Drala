import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_type_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('uses the color picker style on ${theme.brightness}',
        (tester) async {
      var selected = TransactionType.income;
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 240,
              child: StatefulBuilder(
                builder: (context, setState) => TransactionTypeSelector(
                  value: selected,
                  incomeLabel: 'Income',
                  expenseLabel: 'Expense',
                  onChanged: (type) => setState(() => selected = type),
                ),
              ),
            ),
          ),
        ),
      ));

      final control = tester.widget<CupertinoSlidingSegmentedControl<TransactionType>>(
        find.byType(CupertinoSlidingSegmentedControl<TransactionType>),
      );
      expect(control.groupValue, TransactionType.income);
      expect(control.thumbColor, theme.colorScheme.outline);
      expect(control.backgroundColor, theme.colorScheme.surfaceContainer);

      await tester.tap(find.byKey(const ValueKey('transaction-type-expense')));
      await tester.pumpAndSettle();
      expect(selected, TransactionType.expense);
      expect(
        tester
            .widget<CupertinoSlidingSegmentedControl<TransactionType>>(
              find.byType(CupertinoSlidingSegmentedControl<TransactionType>),
            )
            .groupValue,
        TransactionType.expense,
      );
    });
  }
}
