import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/home/domain/errors/insufficient_funds_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/offline_fixture.dart';

void main() {
  test('new income can reduce an already negative wallet balance', () async {
    final f = OfflineFixture();
    addTearDown(f.database.close);
    await f.engine.sync();
    await f.local.mutations.add(ManualEntryInput(
      title: 'Expense',
      amount: 1500,
      transactionType: 'expense',
      occurredAt: DateTime(2026, 10, 27),
      categoryId: OfflineFixture.category,
      sourceWalletId: OfflineFixture.wallet,
    ));
    await f.local.mutations.add(ManualEntryInput(
      title: 'Income',
      amount: 100,
      transactionType: 'income',
      occurredAt: DateTime(2026, 10, 27),
      sourceWalletId: OfflineFixture.wallet,
    ));
    expect((await f.local.wallets.wallets()).single.balance, -400);
    expect(await f.outbox.count(), 2);
  });
  test('spent income cannot be removed and a rejected edit stays atomic',
      () async {
    final f = OfflineFixture();
    addTearDown(f.database.close);
    await f.engine.sync();
    final income = await f.local.mutations.add(ManualEntryInput(
      title: 'Income',
      amount: 500,
      transactionType: 'income',
      occurredAt: DateTime(2026, 10, 27),
      sourceWalletId: OfflineFixture.wallet,
    ));
    await f.local.mutations.add(ManualEntryInput(
      title: 'Expense',
      amount: 1400,
      transactionType: 'expense',
      occurredAt: DateTime(2026, 10, 27),
      categoryId: OfflineFixture.category,
      sourceWalletId: OfflineFixture.wallet,
    ));
    final pending = await f.outbox.count();
    await expectLater(f.local.mutations.delete(income.id),
        throwsA(isA<InsufficientFundsException>()));
    expect((await f.local.wallets.wallets()).single.balance, 100);
    expect(await f.outbox.count(), pending);
    await f.local.mutations.update(
        income.id,
        ManualEntryInput(
          title: 'Corrected income',
          amount: 550,
          transactionType: 'income',
          occurredAt: DateTime(2026, 10, 27),
          sourceWalletId: OfflineFixture.wallet,
        ));
    expect((await f.local.wallets.wallets()).single.balance, 150);
    expect(await f.outbox.count(), pending + 1);
  });
}
