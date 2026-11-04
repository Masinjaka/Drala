import 'package:drift/drift.dart' show QueryExecutor;
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:budgets/features/offline/data/services/offline_outbox_store.dart';
import 'package:budgets/features/offline/data/services/offline_snapshot_store.dart';
import 'package:budgets/features/offline/data/services/offline_sync_engine.dart';
import 'package:drift/native.dart';
import 'fake_offline_remote.dart';

class OfflineFixture {
  OfflineFixture(
      {this.id = '00000000-0000-0000-0000-000000000001',
      QueryExecutor? executor}) {
    database = GuestDatabase.account(id, executor ?? NativeDatabase.memory());
    local = GuestRepositories(database, id);
    remote = FakeOfflineRemote(id);
    outbox = OfflineOutboxStore(database);
    snapshot = OfflineSnapshotStore(database, id);
    engine = OfflineSyncEngine(remote, outbox, snapshot);
    remote.tables.addAll({
      'user': [
        {'_key': id, 'user_id': id, 'username': 'Masy', 'currency_code': 'MGA'}
      ],
      'wallets': [
        {
          '_key': wallet,
          'id': wallet,
          'user_id': id,
          'name': 'Cash',
          'balance': 1000,
          'currency_code': 'MGA',
          'icon_key': 'wallet',
          'is_default': true
        }
      ],
      'categories': [
        {
          '_key': category,
          'id': category,
          'user_id': id,
          'name': 'Food',
          'transaction_type': 'expense',
          'emoji': '🍎',
          'icon_key': 'food'
        }
      ],
    });
  }
  static const wallet = '10000000-0000-0000-0000-000000000001';
  static const category = '20000000-0000-0000-0000-000000000001';
  final String id;
  late final GuestDatabase database;
  late final GuestRepositories local;
  late final FakeOfflineRemote remote;
  late final OfflineOutboxStore outbox;
  late final OfflineSnapshotStore snapshot;
  late final OfflineSyncEngine engine;
}
