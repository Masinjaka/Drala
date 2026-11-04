import 'dart:io';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:budgets/features/offline/data/services/offline_outbox_store.dart';
import 'package:budgets/features/offline/data/services/offline_snapshot_store.dart';
import 'package:budgets/features/offline/data/services/offline_sync_engine.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/offline_fixture.dart';

void main() {
  test('cached account, edits, and retry identity survive process restart',
      () async {
    final directory = await Directory.systemTemp.createTemp('drala-offline-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/account.sqlite');
    final f = OfflineFixture(executor: NativeDatabase(file));
    await f.engine.sync();
    await GuestSyncJournal(f.database).record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'Changed'});
    f.remote.loseAcknowledgement = true;
    await expectLater(f.engine.sync(), throwsA(isA<SocketException>()));
    final batch = (await f.outbox.batch())!;
    await f.database.close();
    final reopened = GuestDatabase.account(f.id, NativeDatabase(file));
    addTearDown(reopened.close);
    final outbox = OfflineOutboxStore(reopened);
    expect((await outbox.batch())!.id, batch.id);
    expect(
        (await GuestRepositories(reopened, f.id).wallets.wallets())
            .single
            .balance,
        1000);
    await OfflineSyncEngine(
            f.remote, outbox, OfflineSnapshotStore(reopened, f.id))
        .sync();
    expect(f.remote.commits, 1);
    expect(await outbox.count(), 0);
  });
}
