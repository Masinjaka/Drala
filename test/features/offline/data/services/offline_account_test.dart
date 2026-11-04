import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/offline_fixture.dart';

void main() {
  test(
      'network failure enters offline mode and reconnect syncs the durable queue',
      () async {
    final f = OfflineFixture();
    final network = OfflineConnectivity();
    final account = OfflineAccount(f.database, f.remote, network);
    addTearDown(network.dispose);
    addTearDown(account.close);
    await account.initialize();
    await account.synchronize();
    expect(account.hydrated, isTrue);
    f.remote.offline = true;
    await GuestSyncJournal(f.database).record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'Food'});
    await account.synchronize();
    expect(account.status, SyncStatus.offline);
    expect(network.isOffline, isTrue);
    expect(account.pending, 1);
    f.remote.offline = false;
    await account.retry();
    expect(account.status, SyncStatus.online);
    expect(account.pending, 0);
    expect(network.isOffline, isFalse);
  });
  test(
      'cloud conflict pauses sync without dropping changes or automatic rebasing',
      () async {
    final f = OfflineFixture();
    final network = OfflineConnectivity();
    final account = OfflineAccount(f.database, f.remote, network);
    addTearDown(network.dispose);
    addTearDown(account.close);
    await account.initialize();
    await account.synchronize();
    await GuestSyncJournal(f.database).record(
        'categories', OfflineFixture.category, 'upsert', {'name': 'Food'});
    f.remote.version++;
    await account.synchronize();
    expect(account.status, SyncStatus.conflict);
    expect(network.isOffline, isFalse);
    expect(await f.outbox.count(), 1);
    await account.retry();
    expect(account.status, SyncStatus.conflict);
    expect(f.remote.commits, 0);
    await account.retryReviewedChanges();
    expect(f.remote.commits, 1);
    expect(account.status, SyncStatus.online);
  });
}
