import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/pages/category_page.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_option.dart';
import '../../support/test_categories.dart';

void main() {
  testWidgets('add and edit open the shared category form sheet',
      (tester) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [categoriesProvider.overrideWith(TestCategories.new)],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CategoryPage(),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('detail-add-button')));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryEditorSheet), findsOneWidget);
    expect(find.byKey(const Key('transaction-sheet-surface')), findsOneWidget);
    expect(find.byKey(const Key('delete-transaction')), findsNothing);
    await tester.tap(find.byKey(const Key('close-transaction-sheet')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryEditorSheet), findsOneWidget);
    expect(find.byKey(const Key('delete-transaction')), findsOneWidget);
    expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller
            ?.text,
        'Food');
  });

  testWidgets('icon picker uses the dark app surfaces', (tester) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [categoriesProvider.overrideWith(TestCategories.new)],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CategoryPage(),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('detail-add-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('category-icon-button')));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryIconPicker), findsOneWidget);
    final surface = find.descendant(
        of: find.byType(CategoryIconOption).first,
        matching: find.byType(Material));
    expect(tester.widget<Material>(surface).color,
        AppTheme.darkTheme.colorScheme.surfaceContainerLowest);
  });
}
