import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'prefills existing envelope and saves changed budget and schedule',
      (tester) async {
    (String, int, bool)? saved;
    await _open(tester, onSave: (name, _, amount, monthly) async {
      saved = (name, amount, monthly);
    });
    expect(find.text('Edit envelope'), findsOneWidget);
    expect(find.byKey(const Key('close-transaction-sheet')), findsNothing);
    expect(find.byKey(const Key('delete-transaction')), findsOneWidget);
    expect(tester.getCenter(find.byKey(const Key('cancel-transaction'))).dy,
        tester.getCenter(find.byKey(const Key('save-envelope-button'))).dy);
    expect(find.text('Groceries'), findsOneWidget);
    expect(
        tester
            .widget<SwitchListTile>(
                find.byKey(const Key('envelope-repeat-monthly')))
            .value,
        isTrue);
    await tester.enterText(find.byType(TextFormField).at(0), '200');
    await tester.enterText(find.byType(TextFormField).at(1), 'Weekly food');
    await tester
        .ensureVisible(find.byKey(const Key('envelope-repeat-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('envelope-repeat-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    expect(saved, ('Weekly food', 200, false));
    expect(find.byType(AddEnvelopeSheet), findsNothing);
  });
  testWidgets(
      'grouped zero exposes validation and a positive amount can be saved',
      (tester) async {
    var saves = 0;
    await _open(tester, onSave: (_, __, ___, ____) async {
      saves++;
    });
    final save = find.byKey(const Key('save-envelope-button'));
    final amount = find.byType(TextFormField).first;
    for (final value in ['0', '0 000', '0,000', '']) {
      await tester.enterText(amount, value);
      await tester.pumpAndSettle();
      final button =
          find.descendant(of: save, matching: find.byType(FilledButton));
      expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
      await tester.tap(save);
      await tester.pumpAndSettle();
      final feedback = tester.widget<Semantics>(
          find.byKey(const Key('amount-validation-feedback')));
      expect(feedback.properties.label, 'Enter an amount greater than zero.');
      expect(saves, 0);
    }
    await tester.enterText(amount, '150');
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(saves, 1);
  });

  testWidgets('delete uses the editor action and closes only after success',
      (tester) async {
    var deleted = false;
    await _open(tester, onDelete: () async {
      deleted = true;
    });
    await tester
        .ensureVisible(find.byKey(const ValueKey('delete-transaction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('delete-transaction')));
    await tester.pumpAndSettle();
    expect(deleted, isFalse);
    expect(find.byType(AddEnvelopeSheet), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cancel-delete')));
    await tester.pumpAndSettle();
    expect(deleted, isFalse);
    await tester.tap(find.byKey(const ValueKey('delete-transaction')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-delete')));
    await tester.pumpAndSettle();
    expect(deleted, isTrue);
    expect(find.byType(AddEnvelopeSheet), findsNothing);
  });
}

Future<void> _open(
  WidgetTester tester, {
  Future<void> Function(String, String, int, bool)? onSave,
  Future<void> Function()? onDelete,
}) async {
  await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
          body: Builder(
              builder: (context) => TextButton(
                  onPressed: () => AddEnvelopeSheet.show(context,
                      month: DateTime(2025, 6),
                      envelope: const Envelope(
                          id: 'e',
                          name: 'Groceries',
                          categoryId: 'food',
                          categoryName: 'Food',
                          emoji: '🍔',
                          color: 'FF888888',
                          amount: 100,
                          spent: 20,
                          currencyCode: 'MGA',
                          repeatsMonthly: true),
                      categories: const [
                        EnvelopeCategory(
                            id: 'food',
                            name: 'Food',
                            emoji: '🍔',
                            color: 'FF888888')
                      ],
                      onSave: onSave ?? (_, __, ___, ____) async {},
                      onDelete: onDelete),
                  child: const Text('Open'))))));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
