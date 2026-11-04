import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/pages/category_page.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/test_categories.dart';

void main() {
  for (final edit in [false, true]) {
    for (final dismissal in ['close', 'back', 'barrier']) {
      testWidgets(
          '${edit ? 'edit' : 'add'} sheet $dismissal returns to categories',
          (tester) async {
        tester.view.physicalSize = const Size(375, 800);
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
        await tester.tap(edit
            ? find.text('Food')
            : find.byKey(const Key('category-create')));
        await tester.pumpAndSettle();
        expect(find.byType(CategoryEditorSheet), findsOneWidget);
        if (dismissal == 'close') {
          await tester.tap(find.byKey(
              Key(edit ? 'cancel-transaction' : 'close-transaction-sheet')));
        } else if (dismissal == 'back') {
          await tester.binding.handlePopRoute();
        } else {
          await tester.tapAt(const Offset(10, 100));
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(CategoryEditorSheet), findsNothing);
        expect(find.text('Food'), findsOneWidget);
        // Reopening verifies the returned card and route remain interactive.
        await tester.tap(find.text('Food'));
        await tester.pumpAndSettle();
        expect(find.byType(CategoryEditorSheet), findsOneWidget);
        await tester.tap(find.byKey(const Key('cancel-transaction')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
