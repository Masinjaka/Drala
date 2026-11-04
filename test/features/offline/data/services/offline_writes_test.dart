import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/offline/domain/models/offline_unavailable_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/offline_fixture.dart';

void main() {
  test(
      'manual expense and its outbox entry commit atomically while disconnected',
      () async {
    final f = OfflineFixture();
    addTearDown(f.database.close);
    await f.engine.sync();
    f.remote.offline = true;
    final entry = await f.local.mutations.add(ManualEntryInput(
        title: 'Lunch',
        amount: 100,
        transactionType: 'expense',
        occurredAt: DateTime(2026, 10, 27),
        categoryId: OfflineFixture.category,
        sourceWalletId: OfflineFixture.wallet));
    expect(entry.title, 'Lunch');
    expect((await f.local.wallets.wallets()).single.balance, 900);
    expect(await f.outbox.count(), 1);
    final batch = (await f.outbox.batch())!;
    expect(batch.operations.single['record_id'], entry.id);
  });
  test('a failed local transaction rolls back both data and pending changes',
      () async {
    final f = OfflineFixture();
    addTearDown(f.database.close);
    await f.engine.sync();
    await expectLater(f.database.transaction(() async {
      await f.local.wallets
          .add(const AddWalletInput(name: 'Will roll back', initialBalance: 1));
      throw StateError('abort');
    }), throwsStateError);
    expect(await f.outbox.count(), 0);
    expect(await f.local.wallets.wallets(), hasLength(1));
  });
  test('a never-downloaded account cannot fabricate a new local ledger',
      () async {
    final f = OfflineFixture();
    addTearDown(f.database.close);
    await expectLater(
        f.local.wallets
            .add(const AddWalletInput(name: 'Wallet', initialBalance: 1)),
        throwsA(isA<OfflineUnavailableException>()));
    expect(await f.local.wallets.wallets(), isEmpty);
    expect(await f.outbox.count(), 0);
  });
  test(
      'acknowledgement removes only the uploaded operations, keeping later edits',
      () async {
    final f = OfflineFixture();
    addTearDown(f.database.close);
    await f.engine.sync();
    final journal = GuestSyncJournal(f.database);
    await journal.record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'First'});
    final batch = (await f.outbox.batch())!;
    await journal.record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'Later'});
    await f.outbox.acknowledge(batch, 2);
    expect(await f.outbox.count(), 1);
    expect((await f.outbox.batch())!.id, isNot(batch.id));
  });
}
