import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:budgets/features/home/presentation/widgets/home_scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('requests another page before a fast scroll reaches the end',
      (tester) async {
    var requests = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: HomeScrollLayout(
          header: const SizedBox(height: 48),
          banner: const SizedBox(height: 100),
          calendarBuilder: (_, __) =>
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
          transactions: HomeOperationsList(
            asSliver: true,
            entries: List.generate(30, _entry),
            isLoading: false,
            isAdding: false,
            onEntryTap: (_) {},
          ),
          composer: const SizedBox(height: 48),
          onNearTransactionsEnd: () => requests++,
        ),
      ),
    ));

    await tester.fling(
      find.byKey(const Key('transaction-scroll-view')),
      const Offset(0, -2200),
      4500,
    );
    await tester.pumpAndSettle();

    expect(requests, greaterThan(0));
  });
}

FinanceEntry _entry(int index) => FinanceEntry(
      id: '$index',
      title: 'Entry $index',
      categoryName: 'Food',
      amount: 100,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: 'expense',
      currencyCode: 'MGA',
      iconKey: 'food',
      emoji: '🍔',
    );
