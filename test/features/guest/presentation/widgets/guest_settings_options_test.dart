import 'package:budgets/features/guest/presentation/widgets/guest_settings_options.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_item.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('guest options retain the standard flat settings list',
      (tester) async {
    var notifications = 0;
    var currency = 0;
    var defaultWallet = 0;
    var theme = 0;
    var language = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: GuestSettingsOptions(
          onNotifications: () => notifications++,
          onCurrency: () => currency++,
          onDefaultWallet: () => defaultWallet++,
          onTheme: () => theme++,
          onLanguage: () => language++,
        ),
      ),
    ));

    final groups = tester.widgetList<SettingsMenuGroup>(
      find.byType(SettingsMenuGroup),
    );
    expect(groups, hasLength(2));
    expect(groups.every((group) => group.flat), isTrue);
    final items = tester
        .widgetList<SettingsMenuItem>(
          find.byType(SettingsMenuItem),
        )
        .toList();
    expect(items.map((item) => item.iconAsset), [
      'assets/settings/notification.svg',
      'assets/settings/currency.svg',
      'assets/settings/privacy.svg',
      'assets/settings/wallet.svg',
      'assets/settings/language.svg',
    ]);

    for (final item in items) {
      await tester.tap(find.text(item.title));
      await tester.pump();
    }
    expect([notifications, currency, defaultWallet, theme, language],
        [1, 1, 1, 1, 1]);
  });
}
