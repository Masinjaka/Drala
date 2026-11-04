import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/manual_entry_test_categories.dart';

void main() {
  testWidgets('manual category picker opens the shared category editor',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        categoriesProvider.overrideWith(ManualEntryTestCategories.new)
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ManualEntrySheet.show(
                context,
                categories: Future<List<ManualEntryCategory>>.value(const []),
                targetDate: DateTime(2026, 10, 16),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('transaction-category-field')),
    );
    await tester.tap(find.byKey(const ValueKey('transaction-category-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('category-create')));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryEditorSheet), findsOneWidget);
    final editor = find.byType(CategoryEditorSheet);
    await tester.enterText(
      find.descendant(of: editor, matching: find.byType(TextFormField)),
      'Groceries',
    );
    await tester.tap(find.byKey(const Key('category-icon-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-icon-shopping')));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(
      of: editor,
      matching: find.byKey(const Key('save-transaction')),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryEditorSheet), findsNothing);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.byKey(const Key('save-transaction')), findsOneWidget);
    expect(find.byKey(const Key('category-search')), findsNothing);
  });
}
