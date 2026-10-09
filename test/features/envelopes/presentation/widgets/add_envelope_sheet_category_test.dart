import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_chip.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens as a manual-entry styled category sheet', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byKey(const Key('transaction-sheet-surface')), findsOneWidget);
    await tester
        .ensureVisible(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    final chip = find.byType(TransactionCategoryChip);
    expect(tester.widget<TransactionCategoryChip>(chip).selected, isFalse);
    await tester.tap(find.byKey(const Key('category-food')));
    await tester.pumpAndSettle();
    expect(tester.widget<TransactionCategoryChip>(chip).selected, isTrue);
    await tester.tap(find.byKey(const Key('category-done')));
    await tester.pumpAndSettle();
    expect(find.text('🍔 Food'), findsOneWidget);
  });
}

Widget _app() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => AddEnvelopeSheet.show(
            context,
            categories: const [_food],
            month: DateTime(2026, 7),
            onSave: (_, __, ___, ____) async {},
          ),
          child: const Text('Open'),
        ),
      ),
    ),
  );
}

const _food = EnvelopeCategory(
  id: 'food',
  name: 'Food',
  emoji: '🍔',
  color: 'FF888888',
);
