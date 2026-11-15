import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../guest/support/guest_finance_fixture.dart';

void main() {
  testWidgets(
      'editing shows the original non-default wallet and changes its balance only',
      (tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    final bank = fixture.wallets.firstWhere((wallet) => wallet.name == 'Bank');
    final month = DateTime(2026, 10);
    await fixture.repositories.envelopeRepository.addEnvelope(
        name: 'Internet budget',
        categoryId: 'food',
        amount: 100,
        month: month,
        walletId: bank.id);
    final original =
        (await fixture.repositories.envelopes.envelopesForMonth(month)).single;
    expect(original.fundingWalletId, bank.id);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EnvelopePage(
          repository: fixture.repositories.envelopeRepository,
          initialMonth: month),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('envelope-${original.id}')));
    await tester.pumpAndSettle();
    final wallet = find.byKey(const Key('envelope-funding-wallet'));
    expect(find.descendant(of: wallet, matching: find.text('Bank account')),
        findsOneWidget);
    expect(tester.widget<InkWell>(wallet).onTap, isNull);
    expect(find.text('An existing envelope keeps its original funding wallet.'),
        findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '150');
    await tester.enterText(find.byType(TextFormField).at(1), 'Internet');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-envelope-button')));
    await tester.pumpAndSettle();
    final saved =
        (await fixture.repositories.envelopes.envelopesForMonth(month)).single;
    expect(saved.name, 'Internet');
    expect(saved.amount, 150);
    expect(saved.fundingWalletId, bank.id);
    final wallets = await fixture.repositories.wallets.wallets();
    expect(wallets.firstWhere((w) => w.id == bank.id).balance, 850);
    expect(wallets.firstWhere((w) => w.isDefault).balance, 1000);
    expect(tester.takeException(), isNull);
  });
}
