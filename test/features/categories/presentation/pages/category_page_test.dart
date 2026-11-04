import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/pages/category_page.dart';
import 'package:budgets/features/categories/presentation/widgets/category_type_carousel.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/test_categories.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('category tabs and controls work in ${theme.brightness}',
        (tester) async {
      tester.view.physicalSize = const Size(375, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
          overrides: [categoriesProvider.overrideWith(TestCategories.new)],
          child: MaterialApp(
              theme: theme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const CategoryPage())));
      await tester.pumpAndSettle();
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Salary'), findsNothing);
      expect(find.byType(CategoryTypeCarousel), findsOneWidget);
      final buttons = tester
          .widgetList<OutlinedSquareButton>(find.byType(OutlinedSquareButton));
      expect(
          buttons.every(
              (button) => button.visualSize == AppHeaderMetrics.buttonSize),
          isTrue);
      await tester.tap(find.text('Income'));
      await tester.pumpAndSettle();
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('Food'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
