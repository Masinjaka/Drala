import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/reference_wallet_field.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_selection_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _wallets = [
  WalletSummary(
      id: 'cash',
      name: 'Cash',
      balance: 10000,
      currencyCode: 'MGA',
      iconKey: 'cash',
      isDefault: true),
  WalletSummary(
      id: 'bank',
      name: 'Reserve',
      balance: 20000,
      currencyCode: 'MGA',
      iconKey: 'bank',
      isDefault: false),
];

Future<void> _host(
    WidgetTester tester, VoidCallback Function(BuildContext) open) async {
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
        body: Builder(
            builder: (context) => TextButton(
                onPressed: open(context), child: const Text('Open')))),
  ));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'wallet picker searches, returns selection, and cancels without change',
      (tester) async {
    String? result = 'initial';
    await _host(
        tester,
        (context) => () async {
              result = await WalletSelectionSheet.show(context,
                  wallets: _wallets, selected: 'cash', label: 'Wallet');
            });
    expect(find.textContaining('20 000'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('wallet-search')), 'Res');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('wallet-choice-cash')), findsNothing);
    await tester.tap(find.byKey(const Key('wallet-choice-bank')));
    await tester.pumpAndSettle();
    expect(result, 'bank');
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('wallet-picker-close')));
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'transfer wallet sheets exclude source and clear an identical destination',
      (tester) async {
    await _host(
        tester,
        (context) => () => ManualEntrySheet.show(context,
            categories: Future.value([]),
            targetDate: DateTime(2026, 11, 2),
            wallets: _wallets,
            allowTransfers: true));
    await tester.tap(find.byKey(const Key('transaction-type-transfer')));
    await tester.pumpAndSettle();
    Future<void> openField(int index) async {
      final field = find.byType(ReferenceWalletField).at(index);
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();
    }

    await openField(1);
    expect(find.byKey(const Key('wallet-choice-cash')), findsNothing);
    expect(find.byKey(const Key('wallet-choice-bank')), findsOneWidget);
    await tester.tap(find.byKey(const Key('wallet-picker-close')));
    await tester.pumpAndSettle();
    await openField(0);
    await tester.tap(find.byKey(const Key('wallet-choice-bank')));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<ReferenceWalletField>(
                find.byType(ReferenceWalletField).last)
            .value,
        isNull);
    await openField(1);
    expect(find.byKey(const Key('wallet-choice-bank')), findsNothing);
    await tester.tap(find.byKey(const Key('wallet-choice-cash')));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<ReferenceWalletField>(
                find.byType(ReferenceWalletField).last)
            .value,
        'cash');
    expect(tester.takeException(), isNull);
  });
}
