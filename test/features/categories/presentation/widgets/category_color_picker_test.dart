import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_color_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final save in [false, true]) {
    testWidgets(
        'color picker ${save ? 'confirms' : 'cancels'} changes without mutating input',
        (tester) async {
      Color? result;
      const initial = Color(0xFF8040C0), selected = Color(0xFF208080);
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
              body: Builder(
                  builder: (context) => TextButton(
                      onPressed: () async {
                        result =
                            await CategoryColorPicker.show(context, initial);
                      },
                      child: const Text('Open'))))));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      tester
          .widget<ColorPicker>(find.byType(ColorPicker))
          .onColorChanged(selected);
      await tester.pumpAndSettle();
      await tester.tap(save
          ? find.byKey(const Key('save-transaction'))
          : find.byKey(const Key('close-transaction-sheet')));
      await tester.pumpAndSettle();
      expect(result, save ? selected : null);
      expect(initial, const Color(0xFF8040C0));
      expect(tester.takeException(), isNull);
    });
  }
}
