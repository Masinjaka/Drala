import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/load_app_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  testWidgets('matches the Figma wallets frame', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    tester.view.padding = const FakeViewPadding(top: 24);
    tester.view.viewPadding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WalletsPage(
          wallets: _wallets,
          onAddWallet: (_) async {},
          onUpdateWallet: (_, __) async {},
          onDeleteWallet: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/wallets_figma.png'),
    );
  });
}

const _wallets = [
  WalletSummary(
    id: 'cash',
    name: 'Cash',
    balance: 250000,
    currencyCode: 'MGA',
    iconKey: 'cash',
    isDefault: true,
  ),
  WalletSummary(
    id: 'bank',
    name: 'Bank',
    balance: 250000,
    currencyCode: 'MGA',
    iconKey: 'bank',
    isDefault: false,
  ),
  WalletSummary(
    id: 'mobile',
    name: 'Mobile Money',
    balance: 250000,
    currencyCode: 'MGA',
    iconKey: 'mobile',
    isDefault: false,
  ),
];
