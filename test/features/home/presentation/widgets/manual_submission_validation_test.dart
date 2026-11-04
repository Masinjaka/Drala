import 'package:budgets/core/theme.dart';
import 'package:budgets/features/transactions/presentation/widgets/amount_validation_field.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'typing and clearing amount stays quiet until Save, then corrections clear errors',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () => ManualEntrySheet.show(context,
                        categories: Future.value([]),
                        targetDate: DateTime(2026, 11, 2),
                        allowTransfers: true),
                    child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final amount = find.byKey(const Key('transaction-amount'));
    await tester.enterText(amount, '20');
    await tester.pumpAndSettle();
    await tester.enterText(amount, '');
    await tester.pumpAndSettle();
    await tester.enterText(amount, '0');
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    expect(find.text('Description'), findsNothing);
    await tester.tap(find.byKey(const Key('transaction-type-income')));
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    await tester.tap(find.byKey(const Key('transaction-type-transfer')));
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    expect(find.textContaining('deuxième portefeuille'), findsNothing);
    await tester.tap(find.byKey(const Key('transaction-type-expense')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-transaction')));
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    expect(
        tester
            .state<FormFieldState<String>>(find.byType(AmountValidationField))
            .errorText,
        contains('supérieur à zéro'));
    expect(find.byType(ManualEntrySheet), findsOneWidget);
    await tester
        .ensureVisible(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-back')));
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    expect(
        tester
            .state<FormFieldState<String>>(find.byType(AmountValidationField))
            .errorText,
        contains('supérieur à zéro'));
    await tester.ensureVisible(amount);
    await tester.pumpAndSettle();
    await tester.enterText(amount, '30');
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    await tester
        .ensureVisible(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.textContaining('supérieur à zéro'), findsNothing);
    await tester
        .ensureVisible(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
