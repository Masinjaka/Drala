import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/home_operations_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('first three real rows animate after loading skeletons',
      (tester) async {
    await tester.pumpWidget(_app(isLoading: true));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.pumpWidget(_app(entries: List.generate(3, _entry)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 110));
    await tester.pump(const Duration(milliseconds: 60));

    for (var index = 0; index < 3; index++) {
      final row = find.byKey(ValueKey('operation-$index'));
      final fade = tester.widget<FadeTransition>(
        find.ancestor(of: row, matching: find.byType(FadeTransition)).first,
      );
      expect(fade.opacity.value, inExclusiveRange(0, 1));
    }
  });

  testWidgets('keeps loaded rows and shows skeletons for the next page',
      (tester) async {
    await tester.pumpWidget(
      _app(entries: List.generate(2, _entry), isLoadingMore: true),
    );

    expect(find.byKey(const ValueKey('operation-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('operation-1')), findsOneWidget);
    expect(find.byType(HomeOperationSkeleton), findsNWidgets(3));
    await tester.pump(const Duration(milliseconds: 300));
  });
}

Widget _app({
  List<FinanceEntry> entries = const [],
  bool isLoading = false,
  bool isLoadingMore = false,
}) =>
    MaterialApp(
      home: Scaffold(
        body: HomeOperationsList(
          entries: entries,
          isLoading: isLoading,
          isLoadingMore: isLoadingMore,
          isAdding: false,
          onEntryTap: (_) {},
        ),
      ),
    );

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
