import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final (code, settings, logout, version) in [
    ('mg', 'Fikirana', 'Hivoaka', 'Dika 2.0.2'),
    ('de', 'Einstellungen', 'Abmelden', 'Version 2.0.2'),
    ('es', 'Ajustes', 'Cerrar sesión', 'Versión 2.0.2'),
    ('it', 'Impostazioni', 'Esci', 'Versione 2.0.2'),
  ]) {
    test('$code has translated settings and a version label', () async {
      final locale = Locale(code);
      expect(AppLocalizations.supportedLocales, contains(locale));
      final strings = await AppLocalizations.delegate.load(locale);
      expect(strings.settings, settings);
      expect(strings.logOut, logout);
      expect(strings.appVersion('2.0.2'), version);
      expect(strings.envelopeBudgetReached('Food'), contains('Food'));
    });
  }
}
