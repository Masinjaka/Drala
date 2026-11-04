import 'package:budgets/features/home/domain/errors/wallet_deletion_exception.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/guest_finance_fixture.dart';

void main() {
  test(
      'wallet batch rolls back every deletion and journal record when one is in use',
      () async {
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    final ids = fixture.wallets
        .where((w) => !w.isDefault)
        .map((w) => w.id)
        .toList()
      ..sort();
    await fixture.repositories.envelopeRepository.addEnvelope(
        name: 'Food',
        categoryId: 'food',
        amount: 100,
        month: DateTime(2026, 10),
        walletId: ids.last);
    await expectLater(fixture.repositories.finance.deleteWallets(ids),
        throwsA(isA<WalletDeletionException>()));
    expect(await fixture.repositories.wallets.wallets(), hasLength(3));
    expect(
        await fixture.database
            .customSelect(
                "SELECT * FROM guest_sync_records WHERE operation='delete'")
            .get(),
        isEmpty);
    final protected = [
      ids.first,
      fixture.wallets.firstWhere((w) => w.isDefault).id
    ];
    await expectLater(fixture.repositories.finance.deleteWallets(protected),
        throwsA(isA<WalletDeletionException>()));
    expect(await fixture.repositories.wallets.wallets(), hasLength(3));
  });

  test(
      'envelope batch refunds once, rolls back failures and preserves expense reversibility',
      () async {
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    await fixture.fundEnvelopes();
    final entry = await fixture.repositories.mutations.add(ManualEntryInput(
        title: 'Lunch',
        amount: 30,
        transactionType: 'expense',
        categoryId: 'food',
        occurredAt: DateTime(2026, 10, 20),
        sourceWalletId: fixture.wallets.first.id));
    final envelopes = await fixture.repositories.envelopeRepository
        .envelopesForMonth(DateTime(2026, 10));
    final ids = envelopes.map((e) => e.id).toList();
    await expectLater(
        fixture.repositories.envelopeRepository
            .deleteEnvelopes([ids.first, 'missing']),
        throwsStateError);
    expect(
        await fixture.repositories.envelopeRepository
            .envelopesForMonth(DateTime(2026, 10)),
        hasLength(2));
    expect((await fixture.repositories.wallets.wallets()).first.balance, 700);
    await fixture.repositories.envelopeRepository
        .deleteEnvelopes([...ids, ids.first]);
    expect(
        await fixture.repositories.envelopeRepository
            .envelopesForMonth(DateTime(2026, 10)),
        isEmpty);
    expect((await fixture.repositories.wallets.wallets()).first.balance, 970);
    await fixture.repositories.mutations.delete(entry.id);
    expect((await fixture.repositories.wallets.wallets()).first.balance, 1000);
  });
}
