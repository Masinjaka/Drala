import 'dart:io';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/offline_fixture.dart';

void main() {
  late OfflineFixture fixture;
  setUp(() => fixture = OfflineFixture());
  tearDown(() => fixture.database.close());
  test(
      'downloads a complete account before publishing and skips unchanged revisions',
      () async {
    expect(await fixture.engine.sync(), isTrue);
    expect((await fixture.local.wallets.wallets()).single.balance, 1000);
    expect(await fixture.outbox.state('hydrated'), '1');
    expect(await fixture.engine.sync(), isFalse);
  });
  test(
      'foreign account rows are rejected without publishing a partial snapshot',
      () async {
    fixture.remote.tables['categories']!.first['user_id'] = 'another-account';
    await expectLater(fixture.engine.sync(), throwsStateError);
    expect(await fixture.local.wallets.wallets(), isEmpty);
    expect(await fixture.outbox.state('hydrated'), isNull);
  });
  test(
      'lost acknowledgement retries the same durable batch without a second commit',
      () async {
    await fixture.engine.sync();
    await GuestSyncJournal(fixture.database).record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'Food'});
    fixture.remote.loseAcknowledgement = true;
    await expectLater(fixture.engine.sync(), throwsA(isA<SocketException>()));
    final first = (await fixture.outbox.batch())!;
    expect(await fixture.outbox.count(), 1);
    await fixture.engine.sync();
    expect(fixture.remote.commits, 1);
    expect(fixture.remote.batches.last.id, first.id);
    expect(await fixture.outbox.count(), 0);
  });
  test('an acknowledged push does not skip its download after a restart',
      () async {
    await fixture.engine.sync();
    await GuestSyncJournal(fixture.database).record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'Changed'});
    fixture.remote.failChanges = true;
    await expectLater(fixture.engine.sync(), throwsA(isA<SocketException>()));
    expect(await fixture.outbox.count(), 0);
    expect(await fixture.outbox.state('revision'), '2');
    expect(await fixture.outbox.state('pulled_revision'), '1');
    fixture.remote.failChanges = false;
    expect(await fixture.engine.sync(), isTrue);
    expect(await fixture.outbox.state('pulled_revision'), '2');
  });
  test('a local edit during a full download is never replaced', () async {
    fixture.remote.beforePage = (table) async {
      if (table != 'categories') return;
      await fixture.outbox.setState('hydrated', '1');
      await fixture.local.wallets.add(
          const AddWalletInput(name: 'Offline wallet', initialBalance: 123));
    };
    await expectLater(fixture.engine.sync(), throwsStateError);
    expect(
        (await fixture.local.wallets.wallets()).single.name, 'Offline wallet');
    expect(await fixture.outbox.count(), 1);
  });
  test('incremental deletion removes a cached record without reloading history',
      () async {
    await fixture.engine.sync();
    fixture.remote.version = 2;
    fixture.remote.deltas.add({
      'table': 'categories',
      'revision': 2,
      'payload': {
        '_key': OfflineFixture.category,
        'id': OfflineFixture.category,
        'user_id': fixture.id,
        '_deleted': true
      }
    });
    fixture.remote.beforePage =
        (_) async => throw StateError('Full pull is unnecessary');
    await fixture.engine.sync();
    expect(await fixture.local.entries.categories(), isEmpty);
  });
  test('a changing server snapshot is not installed', () async {
    fixture.remote.beforePage = (table) async {
      if (table == 'categories') fixture.remote.version++;
    };
    await expectLater(fixture.engine.sync(), throwsStateError);
    expect(await fixture.local.wallets.wallets(), isEmpty);
  });
}
