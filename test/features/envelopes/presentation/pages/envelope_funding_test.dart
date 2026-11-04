import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/funding_envelope_repository.dart';

void main() {
  testWidgets('default funding wallet is selected and another wallet can fund',
      (tester) async {
    final repository = FundingEnvelopeRepository();
    await _open(tester, repository);
    final wallet = find.byKey(const Key('envelope-funding-wallet'));
    expect(tester.widget<DropdownButtonFormField<String>>(wallet).initialValue,
        'cash');
    await tester.ensureVisible(wallet);
    await tester.tap(wallet);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bank account').last);
    await tester.pumpAndSettle();
    await _save(tester);
    expect(repository.fundedWallet, 'bank');
  });

  testWidgets('no funds disables confirmation, explains why and opens wallets',
      (tester) async {
    final repository = FundingEnvelopeRepository();
    var openedWallets = false;
    await _open(tester, repository, manage: () async {
      openedWallets = true;
    });
    repository.balance = 0;
    await _save(tester);
    final confirm = find.descendant(
        of: find.byKey(const Key('confirm-wallet-source')),
        matching: find.byType(FilledButton));
    expect(tester.widget<FilledButton>(confirm).onPressed, isNull);
    expect(find.textContaining('does not have enough funds'), findsOneWidget);
    await tester.tap(find.byKey(const Key('manage-funding-wallets')));
    await tester.pumpAndSettle();
    expect(openedWallets, isTrue);
    expect(repository.fundedWallet, isNull);
    expect(find.byKey(const Key('save-envelope-button')), findsOneWidget);
  });
}

Future<void> _open(WidgetTester tester, FundingEnvelopeRepository repository,
    {Future<void> Function()? manage}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: EnvelopePage(repository: repository, onManageWallets: manage),
  ));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Add envelope'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).at(0), '100');
  await tester.enterText(find.byType(TextFormField).at(1), 'Food');
  await tester
      .ensureVisible(find.byKey(const Key('transaction-category-field')));
  await tester.tap(find.byKey(const Key('transaction-category-field')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('category-food-category')));
  await tester.tap(find.byKey(const Key('category-done')));
  await tester.pumpAndSettle();
}

Future<void> _save(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('save-envelope-button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('save-envelope-button')));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(milliseconds: 500));
}
