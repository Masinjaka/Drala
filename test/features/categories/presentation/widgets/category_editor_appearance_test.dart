import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_appearance_field.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/recording_categories.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'editing converts the legacy emoji to an icon and preserves color in ${theme.brightness}',
        (tester) async {
      final categories = RecordingCategories();
      final existing = Category(
          id: 'internet',
          name: 'Internet',
          emoji: '🌐',
          color: 'FF123456',
          transactionType: TransactionType.expense);
      await _open(tester, categories, theme, category: existing);
      final appearance = tester.widget<CategoryAppearanceField>(
          find.byType(CategoryAppearanceField));
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(categories.edited.single.iconKey, appearance.iconKey);
      expect(categories.edited.single.color,
          appearance.color.toARGB32().toRadixString(16).padLeft(8, '0'));
      expect(categories.edited.single.iconKey, 'internet');
      expect(categories.edited.single.emoji, isEmpty);
      expect(categories.edited.single.color, 'ff123456');
    });

    testWidgets(
        'new categories save the displayed defaults in ${theme.brightness}',
        (tester) async {
      final categories = RecordingCategories();
      await _open(tester, categories, theme);
      final appearance = tester.widget<CategoryAppearanceField>(
          find.byType(CategoryAppearanceField));
      expect(appearance.iconKey, 'other');
      await tester.enterText(find.byType(TextFormField), 'Internet');
      await tester.ensureVisible(find.byKey(const Key('save-transaction')));
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(categories.saved.single.iconKey, appearance.iconKey);
      expect(categories.saved.single.emoji, isEmpty);
      expect(categories.saved.single.color,
          appearance.color.toARGB32().toRadixString(16).padLeft(8, '0'));
    });
  }
}

Future<void> _open(
    WidgetTester tester, RecordingCategories categories, ThemeData theme,
    {Category? category}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [categoriesProvider.overrideWith(() => categories)],
    child: MaterialApp(
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
          body: Builder(
              builder: (context) => TextButton(
                    onPressed: () => CategoryEditorSheet.show(context,
                        type: TransactionType.expense, category: category),
                    child: const Text('Open'),
                  ))),
    ),
  ));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
