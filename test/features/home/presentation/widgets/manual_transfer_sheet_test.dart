import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'transfer tab converts selected currency and keeps source and destination distinct',
      (tester) async {
    ManualEntrySheetResult? result;
    await _open(tester, _wallets, (value) => result = value);
    await tester.tap(find.byKey(const Key('transaction-type-transfer')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('transaction-amount')), '1');
    final save = find.byKey(const Key('save-manual-transfer'));
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(result?.transferInput?.amount, 5000);
    expect(result?.transferInput?.fromWalletId, 'cash');
    expect(result?.transferInput?.toWalletId, 'bank');
    expect(result?.transferInput?.occurredAt.day, 20);
    expect(result?.action, ManualEntrySheetAction.transfer);
  });

  testWidgets('transfer Save reports when a second wallet is missing',
      (tester) async {
    await _open(tester, [_wallets.first], (_) {});
    await tester.tap(find.byKey(const Key('transaction-type-transfer')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('transaction-amount')), '1');
    final save = find.byKey(const Key('save-manual-transfer'));
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    final button =
        find.descendant(of: save, matching: find.byType(FilledButton));
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
    expect(find.textContaining('Add a second wallet'), findsNothing);
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.textContaining('Add a second wallet'), findsOneWidget);
    await tester
        .ensureVisible(find.byKey(const Key('transaction-type-income')));
    await tester.tap(find.byKey(const Key('transaction-type-income')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save-transaction')), findsOneWidget);
  });
  testWidgets(
      'transfer stays reachable on a small phone with large German text',
      (tester) async {
    await _open(tester, _wallets, (_) {},
        size: const Size(320, 640),
        locale: const Locale('de'),
        textScaler: const TextScaler.linear(1.5));
    await tester.tap(find.byKey(const Key('transaction-type-transfer')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-manual-transfer')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save-manual-transfer')).hitTestable(),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(WidgetTester tester, List<WalletSummary> wallets,
    ValueChanged<ManualEntrySheetResult?> onResult,
    {Size size = const Size(412, 917),
    Locale locale = const Locale('en'),
    TextScaler textScaler = TextScaler.noScaling}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    locale: locale,
    builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
        body: Builder(
            builder: (context) => TextButton(
                  onPressed: () async => onResult(await ManualEntrySheet.show(
                      context,
                      categories: Future.value([]),
                      targetDate: DateTime(2026, 10, 20),
                      wallets: wallets,
                      allowTransfers: true,
                      currencyState: const CurrencyState(
                          code: 'USD',
                          baseCode: 'MGA',
                          rates: {'MGA': 1, 'USD': .0002}))),
                  child: const Text('Open'),
                ))),
  ));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

const _wallets = [
  WalletSummary(
      id: 'cash',
      name: 'Cash',
      balance: 10000,
      currencyCode: 'MGA',
      iconKey: 'wallet',
      isDefault: true),
  WalletSummary(
      id: 'bank',
      name: 'Bank',
      balance: 0,
      currencyCode: 'MGA',
      iconKey: 'bank',
      isDefault: false),
];
