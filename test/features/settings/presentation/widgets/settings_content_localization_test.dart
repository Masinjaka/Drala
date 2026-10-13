import 'package:budgets/features/settings/presentation/widgets/settings_content.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the active settings content in French', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SettingsContent(
            profileHeader: const Text('John Doe'),
            categoryCount: 12,
            walletCount: 3,
            onCategories: () {},
            onWallets: () {},
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
            onLogout: () {},
            isLoggingOut: false,
          ),
        ),
      ),
    );

    expect(find.text('Catégories'), findsOneWidget);
    expect(find.text('Portefeuilles'), findsOneWidget);
    expect(find.text('Modifier le profil'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Langue'), 200);
    expect(find.text('Langue'), findsOneWidget);
  });
}
