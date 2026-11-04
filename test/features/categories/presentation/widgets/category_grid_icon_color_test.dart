import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_category_theme.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/presentation/widgets/category_grid_card.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    for (final swatch in [0xFF123456, 0xFFFF8800, 0xFFFFFFFF, 0xFF000000]) {
      testWidgets('saved icon $swatch remains visible in ${theme.brightness}',
          (tester) async {
        await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Scaffold(
              body: Center(
                  child: SizedBox(
            width: 160,
            height: 144,
            child: CategoryGridCard(
                category: Category(
                    id: 'food',
                    name: 'Food',
                    iconKey: 'food',
                    color: swatch.toRadixString(16),
                    transactionType: TransactionType.expense),
                type: TransactionType.expense),
          ))),
        ));
        await tester.pumpAndSettle();
        final icon = tester.widget<Icon>(find.descendant(
            of: find.byType(CategoryIcon), matching: find.byType(Icon)));
        expect(
            AppCategoryTheme.savedIconColor(
                tester.element(find.byType(CategoryIcon)),
                swatch.toRadixString(16)),
            Color(swatch));
        final context = tester.element(find.byType(CategoryIcon));
        final surface = AppCategoryTheme.surface(context);
        expect(_contrast(icon.color!, surface), greaterThanOrEqualTo(3));
        if (_contrast(Color(swatch), surface) >= 3) {
          expect(icon.color, Color(swatch));
        }
        final original = HSLColor.fromColor(Color(swatch));
        final displayed = HSLColor.fromColor(icon.color!);
        if (original.saturation > 0) {
          expect(displayed.hue, closeTo(original.hue, 1));
          expect(displayed.saturation, closeTo(original.saturation, .02));
        }
        expect(
            find.ancestor(
                of: find.byType(CategoryIcon),
                matching: find.byType(Container)),
            findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('legacy RGB and invalid colors use safe theme parsing',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: Builder(builder: (context) {
          expect(AppCategoryTheme.savedIconColor(context, '#123456'),
              const Color(0xFF123456));
          expect(AppCategoryTheme.savedIconColor(context, null),
              AppCategoryTheme.accent(context));
          expect(AppCategoryTheme.savedIconColor(context, 'invalid'),
              AppCategoryTheme.accent(context));
          return const SizedBox();
        })));
  });
}

double _contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return a > b ? (a + .05) / (b + .05) : (b + .05) / (a + .05);
}
