import 'dart:async';
import 'package:budgets/features/home/presentation/widgets/finance_entry_detail_sheet_route.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/home_scroll_test_app.dart';

void main() {
  testWidgets('editing with keyboard preserves the hidden-banner scroll offset',
      (tester) async {
    await pumpHomeScrollApp(tester, count: 3);
    addTearDown(tester.view.resetViewInsets);
    transactionPosition(tester).jumpTo(138);
    await tester.pumpAndSettle();
    final before = transactionPosition(tester).pixels;
    unawaited(showFinanceEntryDetailSheet(tester.element(transactions),
        entry: FinanceEntry(
            id: '1',
            title: 'Lunch',
            description: '',
            categoryName: 'Food',
            categoryId: 'food',
            amount: 100,
            occurredAt: DateTime(2026, 9, 26),
            transactionType: 'expense',
            currencyCode: 'MGA',
            iconKey: 'food',
            emoji: '🍔'),
        categories: Future.value([])));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'Edited lunch');
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-transaction')));
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    expect(transactionPosition(tester).pixels, closeTo(before, 1));
  });
}
