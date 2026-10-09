import 'dart:async';

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens while categories are still loading', (tester) async {
    final categories = Completer<List<ManualEntryCategory>>();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ManualEntrySheet.show(
                context,
                categories: categories.future,
                targetDate: DateTime(2026, 7, 12),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Enter manually'), findsOneWidget);
    await tester.ensureVisible(
        find.byKey(const ValueKey('transaction-category-field')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('transaction-category-field')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    categories.complete(const []);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('returns a manual income for the selected calendar date',
      (tester) async {
    ManualEntrySheetResult? result;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await ManualEntrySheet.show(
                    context,
                    categories: Future.value(const []),
                    targetDate: DateTime(2026, 7, 12),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.text('MGA'), findsOneWidget);
    expect(find.byKey(const ValueKey('delete-transaction')), findsNothing);
    await tester.tap(find.byKey(const Key('transaction-type-income')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'Salary');
    await tester.enterText(find.byType(TextFormField).at(0), '500000');
    expect(find.text('500,000'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key('save-transaction')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();

    final input = result?.input;
    expect(result?.action, ManualEntrySheetAction.save);
    expect(input?.title, 'Salary');
    expect(input?.amount, 500000);
    expect(input?.transactionType, 'income');
    expect(input?.occurredAt, isNotNull);
    expect(input?.occurredAt.year, 2026);
    expect(input?.occurredAt.month, 7);
    expect(input?.occurredAt.day, 12);
  });
}
