import 'package:budgets/core/theme.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/pages/category_page.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/categories/presentation/widgets/category_grid_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/test_categories.dart';

void main() {
  for (final size in [const Size(320, 700), const Size(1024, 900)]) {
    testWidgets('grid and carousel fit $size with large French text',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [categoriesProvider.overrideWith(TestCategories.new)],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(2)),
              child: child!),
          home: const CategoryPage(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(CategoryGridCard), findsOneWidget);
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, size.width < 400 ? 2 : 4);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byKey(const Key('category-type-carousel')),
          const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('Salary'), findsOneWidget);
      await tester.tap(find.byKey(const Key('detail-add-button')));
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<CategoryEditorSheet>(find.byType(CategoryEditorSheet))
              .type,
          TransactionType.income);
      await tester.tap(find.byKey(const Key('close-transaction-sheet')));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(TabBarView), Offset(size.width * .8, 0));
      await tester.pumpAndSettle();
      expect(find.text('Food'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
