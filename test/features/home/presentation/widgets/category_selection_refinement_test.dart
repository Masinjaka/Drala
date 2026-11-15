import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets(
        'category and Create pills match at scale $scale and selecting returns immediately',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: scale == 1 ? AppTheme.lightTheme : AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!),
          home: Scaffold(
              body: Builder(
                  builder: (context) => TextButton(
                      onPressed: () => ManualEntrySheet.show(context,
                          categories: Future.value(const [
                            ManualEntryCategory(
                                id: 'food',
                                name: 'Food',
                                emoji: '',
                                iconKey: 'food',
                                transactionType: 'expense')
                          ]),
                          targetDate: DateTime(2026, 11, 2)),
                      child: const Text('Open'))))));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final field = find.byKey(const Key('transaction-category-field'));
      final sheet = find.byKey(const Key('transaction-sheet-surface'));
      final fieldColor = tester.widget<Material>(field).color;
      final sheetColor = tester.widget<Material>(sheet).color;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();

      final search = find.byKey(const Key('category-search'));
      final picker =
          find.ancestor(of: search, matching: find.byType(Material)).first;
      final chip = find
          .descendant(
            of: find.byKey(const Key('category-food')),
            matching: find.byType(Material),
          )
          .first;
      expect(tester.widget<Material>(picker).color, sheetColor);
      expect(tester.widget<Material>(chip).color, fieldColor);
      expect(
          tester.widget<TextField>(search).decoration?.fillColor, fieldColor);
      expect(find.byKey(const Key('category-done')), findsNothing);
      expect(
          tester.getSize(find.byKey(const Key('category-create'))).height,
          closeTo(tester.getSize(find.byKey(const Key('category-food'))).height,
              .01));
      await tester.enterText(find.byKey(const Key('category-search')), 'Fo');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('category-food')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('save-transaction')), findsOneWidget);
      expect(find.byKey(const Key('category-search')), findsNothing);
      expect(find.text('Food'), findsOneWidget);
      expect(tester.testTextInput.isVisible, isFalse);
      expect(tester.takeException(), isNull);
    });
  }
}
