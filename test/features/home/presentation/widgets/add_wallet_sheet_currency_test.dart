import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/presentation/widgets/add_wallet_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stores a selected-currency wallet balance as MGA',
      (tester) async {
    AddWalletInput? result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await AddWalletSheet.show(
                  context,
                  currencyState: _usd,
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
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(TransactionSheetSurface), findsOneWidget);
    expect(find.byType(TransactionAmountField), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'Savings');
    await tester.enterText(find.byType(TextFormField).at(0), '200');
    await tester.ensureVisible(find.byKey(const Key('confirm-add-wallet')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-add-wallet')));
    await tester.pumpAndSettle();

    expect(result?.initialBalance, 1000000);
  });

  testWidgets('localizes all wallet sheet content in French', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AddWalletSheet.show(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Ajouter un portefeuille'), findsOneWidget);
    expect(find.text('Nom du portefeuille'), findsOneWidget);
    expect(find.text('ex. Épargne'), findsOneWidget);
    expect(find.text('MGA'), findsOneWidget);
    expect(find.text('Wallet name'), findsNothing);
    expect(find.text('Current balance'), findsNothing);
  });
}

const _usd = CurrencyState(
  code: 'USD',
  baseCode: 'MGA',
  rates: {'USD': 0.0002},
);
