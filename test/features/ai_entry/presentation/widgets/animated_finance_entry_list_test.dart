import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/animated_finance_entry_list.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/finance_entry_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps breathing room between transaction rows', (tester) async {
    await tester.pumpWidget(
      _app([_entry('first', 'Breakfast'), _entry('second', 'Lunch')]),
    );

    final first = find.byKey(const ValueKey('finance-entry-first'));
    final second = find.byKey(const ValueKey('finance-entry-second'));
    final distance = tester.getTopLeft(second).dy - tester.getTopLeft(first).dy;

    expect(distance, FinanceEntryItem.height);
  });

  testWidgets('inserts a new entry above existing rows with animation',
      (tester) async {
    final existing = _entry('existing', 'Breakfast');
    await tester.pumpWidget(_app([existing]));

    final existingFinder = find.byKey(
      const ValueKey('finance-entry-existing'),
    );
    final initialY = tester.getTopLeft(existingFinder).dy;

    await tester.pumpWidget(
      _app([_entry('new', 'Lunch'), existing]),
    );
    await tester.pump(const Duration(milliseconds: 140));

    final newFinder = find.byKey(const ValueKey('finance-entry-new'));
    expect(newFinder, findsOneWidget);
    expect(existingFinder, findsOneWidget);
    expect(tester.getTopLeft(existingFinder).dy, greaterThan(initialY));
    expect(
      tester.getTopLeft(newFinder).dy,
      lessThan(tester.getTopLeft(existingFinder).dy),
    );
    final fade = tester.widget<FadeTransition>(find
        .ancestor(
          of: newFinder,
          matching: find.byType(FadeTransition),
        )
        .first);
    expect(fade.opacity.value, inExclusiveRange(0, 1));

    await tester.pumpAndSettle();
  });

  testWidgets('removes an entry and settles remaining rows into place',
      (tester) async {
    final first = _entry('first', 'Breakfast');
    final second = _entry('second', 'Lunch');
    await tester.pumpWidget(_app([first, second]));
    final secondFinder = find.byKey(const ValueKey('finance-entry-second'));
    final initialY = tester.getTopLeft(secondFinder).dy;

    await tester.pumpWidget(_app([second]));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.byKey(const ValueKey('finance-entry-first')), findsOneWidget);
    expect(tester.getTopLeft(secondFinder).dy, lessThan(initialY));

    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('finance-entry-first')), findsNothing);
  });

  testWidgets('uses the new order when existing entries are reordered',
      (tester) async {
    final first = _entry('first', 'Breakfast');
    final second = _entry('second', 'Lunch');
    await tester.pumpWidget(_app([first, second]));

    await tester.pumpWidget(_app([second, first]));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('finance-entry-second'))).dy,
      lessThan(tester
          .getTopLeft(find.byKey(const ValueKey('finance-entry-first')))
          .dy),
    );
  });

  testWidgets('rapid insert then removal leaves no stale transaction row',
      (tester) async {
    final existing = _entry('existing', 'Breakfast');
    final added = _entry('added', 'Lunch');
    await tester.pumpWidget(_app([existing]));
    await tester.pumpWidget(_app([added, existing]));
    await tester.pump(const Duration(milliseconds: 60));
    await tester.pumpWidget(_app([existing]));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('finance-entry-added')), findsNothing);
    expect(
        find.byKey(const ValueKey('finance-entry-existing')), findsOneWidget);
  });

  testWidgets('editing an existing entry refreshes content without entering',
      (tester) async {
    await tester.pumpWidget(_app([_entry('same', 'Breakfast')]));
    final before =
        tester.getTopLeft(find.byKey(const ValueKey('finance-entry-same'))).dy;

    await tester.pumpWidget(_app([_entry('same', 'Brunch')]));
    expect(find.text('Brunch'), findsOneWidget);
    expect(find.text('Breakfast'), findsNothing);
    expect(
        tester.getTopLeft(find.byKey(const ValueKey('finance-entry-same'))).dy,
        before);
  });

  testWidgets('only non-transfer entries invoke the edit callback',
      (tester) async {
    FinanceEntry? tapped;
    final expense = _entry('expense', 'Lunch');
    final transfer = FinanceEntry(
      id: 'transfer',
      title: 'Moved from Cash to Bank',
      categoryName: 'Transfer',
      amount: 5000,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: 'transfer',
      currencyCode: 'MGA',
      iconKey: 'transfer',
      emoji: '🔄',
      entryType: 'transfer',
    );
    await tester.pumpWidget(_app(
      [expense, transfer],
      onEntryTap: (entry) => tapped = entry,
    ));

    await tester.tap(find.byKey(const ValueKey('finance-entry-expense')));
    expect(tapped, same(expense));

    tapped = null;
    await tester.tap(find.byKey(const ValueKey('finance-entry-transfer')));
    expect(tapped, isNull);
  });
}

Widget _app(
  List<FinanceEntry> entries, {
  ValueChanged<FinanceEntry>? onEntryTap,
}) {
  return MaterialApp(
    home: Scaffold(
      body: CustomScrollView(
        slivers: [
          AnimatedFinanceEntryList(
            entries: entries,
            onEntryTap: onEntryTap,
          ),
        ],
      ),
    ),
  );
}

FinanceEntry _entry(String id, String title) => FinanceEntry(
      id: id,
      title: title,
      categoryName: 'Foods & Drinks',
      amount: 24000,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: 'expense',
      currencyCode: 'MGA',
      iconKey: 'food',
      emoji: '🍔',
    );
