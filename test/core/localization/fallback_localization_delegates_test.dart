import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('provides Material localizations for Malagasy', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('mg'),
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          const MalagasyMaterialLocalizationsDelegate(),
          const MalagasyCupertinoLocalizationsDelegate(),
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: TextField()),
      ),
    );

    expect(tester.takeException(), isNull);
    final localizations =
        MaterialLocalizations.of(tester.element(find.byType(TextField)));
    expect(localizations.cancelButtonLabel, 'Annuler');
  });
}
