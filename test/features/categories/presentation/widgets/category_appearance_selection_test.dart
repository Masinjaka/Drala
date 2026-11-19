import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/categories/presentation/widgets/category_color_picker.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/recording_categories.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'preset preview and final custom color save in ${theme.brightness}',
        (tester) async {
      tester.view.physicalSize = const Size(375, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final categories = RecordingCategories();
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
                            type: TransactionType.expense),
                        child: const Text('Open'))))),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final preview = find.byKey(const Key('category-appearance-preview'));
      expect(tester.getTopLeft(preview).dy,
          lessThan(tester.getTopLeft(find.byType(TextFormField)).dy));
      final preset = AppCategoryIconTheme.appearanceColors[2];
      await tester
          .tap(find.byKey(ValueKey('category-color-${preset.toARGB32()}')));
      await tester.pump();
      expect(tester.widget<CategoryIcon>(preview).color, preset);
      await tester.drag(find.byKey(const Key('category-color-choices')),
          const Offset(-700, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('category-color-button')));
      await tester.pumpAndSettle();
      const custom = Color(0xFF8040C0);
      tester
          .widget<ColorPicker>(find.byType(ColorPicker))
          .onColorChanged(custom);
      await tester.pump();
      await tester.tap(find.descendant(
          of: find.byType(CategoryColorPicker),
          matching: find.byKey(const Key('save-transaction'))));
      await tester.pumpAndSettle();
      expect(tester.widget<CategoryIcon>(preview).color, custom);
      await tester.enterText(find.byType(TextFormField), 'Custom category');
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(categories.saved.single.color, 'ff8040c0');
      expect(tester.takeException(), isNull);
    });
  }
}
