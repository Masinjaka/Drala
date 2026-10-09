import 'package:budgets/core/theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_content.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows required ad privacy choices and opens the form',
      (tester) async {
    var opened = false;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SettingsContent(
          profileHeader: const SizedBox(),
          onEditProfile: () {},
          onChangePassword: () {},
          onNotifications: () {},
          onCurrency: () {},
          onDefaultWallet: () {},
          onTheme: () {},
          onLanguage: () {},
          onScannedReceipts: () {},
          onTerms: () {},
          onPrivacy: () {},
          showAdPrivacyOptions: true,
          onAdPrivacyOptions: () => opened = true,
          onLogout: () {},
          isLoggingOut: false,
        ),
      ),
    ));

    final choices = find.text('Ad privacy choices');
    await tester.scrollUntilVisible(choices, 200);
    await tester.pumpAndSettle();
    await tester.tap(choices);
    expect(opened, isTrue);
  });
}
