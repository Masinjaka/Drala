import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/finance_entry_amount_badge.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/finance_entry_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows expenses and incomes in muted status pills',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Column(
            children: [
              FinanceEntryItem(entry: _entry('expense', 'expense')),
              FinanceEntryItem(entry: _entry('income', 'income')),
            ],
          ),
        ),
      ),
    );

    final expense = tester.widget<Text>(
      find.byKey(const Key('finance-entry-amount-expense')),
    );
    final income = tester.widget<Text>(
      find.byKey(const Key('finance-entry-amount-income')),
    );

    expect(
      _badgeColor(tester, 'expense'),
      FinanceEntryAmountBadge.expenseBackground,
    );
    expect(
      _badgeColor(tester, 'income'),
      FinanceEntryAmountBadge.incomeBackground,
    );
    expect(expense.style?.color, Colors.black);
    expect(income.style?.color, Colors.black);
    expect(expense.style?.fontSize, AppTypography.caption);
    expect(income.style?.fontSize, AppTypography.caption);
    expect(expense.data, startsWith('-'));
    expect(income.data, startsWith('+'));
    final title = tester.widget<Text>(find.text('expense'));
    expect(title.style?.fontWeight,
        AppTheme.lightTheme.textTheme.bodyMedium?.fontWeight);
  });

  testWidgets('uses dark status surfaces and readable text', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: FinanceEntryItem(entry: _entry('expense', 'expense')),
      ),
    ));

    expect(_badgeColor(tester, 'expense'), AppTheme.expenseBadgeDark);
    final amount = tester.widget<Text>(
      find.byKey(const Key('finance-entry-amount-expense')),
    );
    expect(amount.style?.color, AppTheme.textDark);
    expect(tester.widget<Text>(find.text('expense')).style?.color,
        AppTheme.darkTheme.textTheme.bodyMedium?.color);
  });

  testWidgets('shows transfers in a blue amount pill', (tester) async {
    final visibilityController = AmountVisibilityController();
    addTearDown(visibilityController.dispose);
    await tester.pumpWidget(
      AmountVisibilityScope(
        controller: visibilityController,
        child: MaterialApp(
          home: Scaffold(
            body: FinanceEntryItem(
              entry: _entry('transfer', 'transfer', entryType: 'transfer'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('🔄'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
    final amount = tester.widget<Text>(
      find.byKey(const Key('finance-entry-amount-transfer')),
    );
    expect(amount.data, '-5 000 MGA');
    expect(
      _badgeColor(tester, 'transfer'),
      FinanceEntryAmountBadge.transferBackground,
    );
    expect(amount.style?.color, Colors.black);
    expect(amount.style?.fontSize, AppTypography.caption);

    visibilityController.toggle();
    await tester.pumpAndSettle();
    expect(find.text('***'), findsOneWidget);
    expect(find.text('-5 000 MGA'), findsNothing);
  });

  testWidgets('renders the category emoji instead of a Material icon',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FinanceEntryItem(
            entry: _entry('meal', 'expense', emoji: '🍜'),
          ),
        ),
      ),
    );

    expect(find.text('🍜'), findsOneWidget);
    expect(find.byIcon(Icons.fastfood_outlined), findsNothing);
  });
}

Color? _badgeColor(WidgetTester tester, String id) {
  final badge = tester.widget<DecoratedBox>(
    find.byKey(Key('finance-entry-amount-badge-$id')),
  );
  return (badge.decoration as BoxDecoration).color;
}

FinanceEntry _entry(
  String id,
  String type, {
  String entryType = 'transaction',
  String? emoji,
}) =>
    FinanceEntry(
      id: id,
      title: entryType == 'transfer' ? 'Moved from Cash to Bank' : id,
      categoryName: entryType == 'transfer' ? 'Transfer' : 'Other',
      amount: 5000,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: type,
      currencyCode: 'MGA',
      iconKey: entryType == 'transfer' ? 'transfer' : 'other',
      emoji: emoji ?? (entryType == 'transfer' ? '🔄' : '🧾'),
      entryType: entryType,
    );
