import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_source_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the shared sheet design and disables short wallets',
      (tester) async {
    String? selectedWallet;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                selectedWallet = await WalletSourceSheet.show(
                  context,
                  wallets: _wallets,
                  requiredAmount: 1000,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app-sheet-surface')), findsOneWidget);
    expect(find.text('Choose another wallet'), findsOneWidget);
    expect(find.text('Insufficient balance'), findsOneWidget);

    final cashTile = tester.widget<InkWell>(
      find.byKey(const Key('wallet-source-cash')),
    );
    expect(cashTile.onTap, isNull);

    await tester.tap(find.byKey(const Key('confirm-wallet-source')));
    await tester.pumpAndSettle();
    expect(selectedWallet, 'bank');
  });

  testWidgets('uses French for the picker and known starter wallet names',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => WalletSourceSheet.show(
              context,
              wallets: const [
                WalletSummary(
                  id: 'main',
                  name: 'Main wallet',
                  balance: 0,
                  currencyCode: 'MGA',
                  iconKey: 'wallet',
                  isDefault: true,
                ),
                WalletSummary(
                  id: 'bank',
                  name: 'Bank account',
                  balance: 300000,
                  currencyCode: 'MGA',
                  iconKey: 'bank',
                  isDefault: false,
                ),
                WalletSummary(
                  id: 'custom',
                  name: 'Vacances',
                  balance: 0,
                  currencyCode: 'MGA',
                  iconKey: 'wallet',
                  isDefault: false,
                ),
              ],
              requiredAmount: 200000,
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir un autre portefeuille'), findsOneWidget);
    expect(find.textContaining('Cette opération nécessite'), findsOneWidget);
    expect(find.text('Portefeuille principal'), findsOneWidget);
    expect(find.text('Compte bancaire'), findsOneWidget);
    expect(find.text('Vacances'), findsOneWidget);
    expect(find.text('Solde insuffisant'), findsNWidgets(2));
    expect(find.text('Utiliser ce portefeuille'), findsOneWidget);
    expect(find.text('Choose another wallet'), findsNothing);
  });
}

const _wallets = [
  WalletSummary(
    id: 'cash',
    name: 'Cash',
    balance: 500,
    currencyCode: 'MGA',
    iconKey: 'wallet',
    isDefault: true,
  ),
  WalletSummary(
    id: 'bank',
    name: 'Bank',
    balance: 1500,
    currencyCode: 'MGA',
    iconKey: 'bank',
    isDefault: false,
  ),
];
