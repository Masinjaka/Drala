import 'package:budgets/features/settings/presentation/pages/language_settings_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest language selection stays local without Supabase',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    String? selected;
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LanguageSettingsPage(
          syncNotifications: false,
          onSelected: (code) async => selected = code,
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();

    expect(selected, 'fr');
    expect(tester.takeException(), isNull);
    expect((await SharedPreferences.getInstance()).getString('selected_locale'),
        'fr');
  });
}
