import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('mg'));

  for (final monthOnly in [false, true]) {
    testWidgets(
        'Malagasy ${monthOnly ? 'month' : 'date'} wheel uses local labels',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('mg'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          MalagasyMaterialLocalizationsDelegate(),
          MalagasyCupertinoLocalizationsDelegate(),
          ...AppLocalizations.localizationsDelegates,
        ],
        home: Builder(
            builder: (context) => TextButton(
                  onPressed: () {
                    final open = monthOnly
                        ? AppWheelPicker.monthYear
                        : AppWheelPicker.date;
                    open(context,
                        initialDate: DateTime(2026, 1, 10),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030));
                  },
                  child: const Text('Open'),
                )),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Misafidiana daty'), findsOneWidget);
      expect(find.text('Janoary'), findsWidgets);
      expect(find.text('janvier'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const Key('app-wheel-picker-close')));
      await tester.pumpAndSettle();
    });
  }
}
