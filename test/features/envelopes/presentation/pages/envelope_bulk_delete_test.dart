import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../guest/support/guest_finance_fixture.dart';

void main() {
  testWidgets('selects several envelopes and refunds only after confirmation',
      (tester) async {
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    await fixture.fundEnvelopes();
    final month = DateTime(2026, 10);
    final envelopes =
        await fixture.repositories.envelopeRepository.envelopesForMonth(month);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EnvelopePage(
          repository: fixture.repositories.envelopeRepository,
          initialMonth: month),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('envelope-page-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('select-items')));
    await tester.pumpAndSettle();
    for (final envelope in envelopes) {
      final checkbox = find.byKey(Key('select-envelope-${envelope.id}'));
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pump();
    }
    await tester.tap(find.byKey(const Key('delete-selected-items')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cancel-delete')));
    await tester.pumpAndSettle();
    expect((await fixture.repositories.wallets.wallets()).first.balance, 700);
    await tester.tap(find.byKey(const Key('delete-selected-items')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete')));
    await tester.pumpAndSettle();
    expect(
        await fixture.repositories.envelopeRepository.envelopesForMonth(month),
        isEmpty);
    expect((await fixture.repositories.wallets.wallets()).first.balance, 1000);
    expect(find.byKey(const Key('envelope-page-menu')), findsOneWidget);
    expect(find.text('Food'), findsNothing);
  });
}
