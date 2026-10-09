import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/animated_finance_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inserts immediately when reduced motion is requested',
      (tester) async {
    var entries = [_entry('first')];
    late StateSetter update;
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!,
      ),
      home: StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return Scaffold(
            body: CustomScrollView(slivers: [
              AnimatedFinanceEntryList(entries: entries),
            ]),
          );
        },
      ),
    ));
    final first = find.byKey(const ValueKey('finance-entry-first'));
    final initialY = tester.getTopLeft(first).dy;

    update(() => entries = [_entry('new'), ...entries]);
    await tester.pump();
    expect(tester.getTopLeft(first).dy, initialY + 76);
    expect(find.byKey(const ValueKey('finance-entry-new')), findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);
  });
}

FinanceEntry _entry(String id) => FinanceEntry(
      id: id,
      title: id,
      categoryName: 'Food',
      amount: 1000,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: 'expense',
      currencyCode: 'MGA',
      iconKey: 'food',
      emoji: '🍔',
    );
