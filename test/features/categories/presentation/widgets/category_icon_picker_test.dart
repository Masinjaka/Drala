import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/category_icons.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_option.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionicons/ionicons.dart';

void main() {
  test('legacy emoji categories resolve to symbols with no emoji fallback', () {
    expect(CategoryIcons.icon(iconKey: 'other', emoji: '🌐'), Ionicons.wifi);
    expect(
        CategoryIcons.icon(iconKey: 'food', emoji: '🚗'), Ionicons.fast_food);
    expect(CategoryIcons.icon(emoji: '☔'), Ionicons.rainy);
    expect(
        CategoryIcons.icon(iconKey: 'unknown', emoji: '🦄'), Ionicons.receipt);
  });

  for (final locale in ['en', 'fr']) {
    testWidgets('searches localized icons and returns a stable key in $locale',
        (tester) async {
      String? selected;
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () async => selected =
                        await CategoryIconPicker.show(context,
                            selected: 'food'),
                    child: const Text('Open')))),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final food = tester.widget<CategoryIconOption>(find.byWidgetPredicate(
          (w) => w is CategoryIconOption && w.iconKey == 'food'));
      expect(food.selected, isTrue);
      await tester.enterText(find.byKey(const Key('category-icon-search')),
          locale == 'fr' ? 'Voyages' : 'Travel');
      await tester.pumpAndSettle();
      expect(find.byType(CategoryIconOption), findsOneWidget);
      await tester.tap(find.byKey(const Key('category-icon-travel')));
      await tester.pumpAndSettle();
      expect(selected, 'travel');
      expect(find.byType(CategoryIconPicker), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
