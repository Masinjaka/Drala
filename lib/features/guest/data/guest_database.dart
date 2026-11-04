import 'package:budgets/features/offline/data/services/offline_schema.dart';
import 'dart:async';
import 'dart:io';

import 'package:budgets/features/guest/data/guest_notification_schema.dart';
import 'package:budgets/features/guest/data/guest_schema.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'guest_account_database.dart';

class GuestDatabase extends GeneratedDatabase {
  GuestDatabase([QueryExecutor? executor])
      : this._(executor ?? _openConnection());
  GuestDatabase._(super.executor, {this.accountId});
  factory GuestDatabase.account(String id, [QueryExecutor? executor]) =>
      _GuestAccountDatabase(
          executor ??
              _openConnection(
                  'drala_account_${Uri.encodeComponent(id)}.sqlite'),
          accountId: id);
  final String? accountId;
  final _syncChanges = StreamController<void>.broadcast();
  Stream<void> get syncChanges => _syncChanges.stream;
  void notifySync() {
    if (!_syncChanges.isClosed) _syncChanges.add(null);
  }

  @override
  int get schemaVersion => 5;

  final _notificationChanges = StreamController<void>.broadcast();
  Stream<void> get notificationChanges => _notificationChanges.stream;
  void notifyNotifications() {
    if (!_notificationChanges.isClosed) _notificationChanges.add(null);
  }

  @override
  Future<void> close() async {
    await _notificationChanges.close();
    await _syncChanges.close();
    await super.close();
  }

  @override
  Iterable<TableInfo> get allTables => const [];

  Future<void> clearAllData() => transaction(() async {
        for (final table in const [
          'offline_staging',
          'offline_state',
          'guest_notifications',
          'guest_wallet_debits',
          'guest_wallet_transfers',
          'guest_transactions',
          'guest_envelopes',
          'guest_wallets',
          'guest_categories',
          'guest_preferences',
          'guest_sync_records',
          'guest_profiles',
        ]) {
          await customStatement('DELETE FROM $table');
        }
      });

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          for (final statement in [...guestSchema, ...offlineSchema]) {
            await customStatement(statement);
          }
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 5) {
            for (final statement in offlineSchema) {
              await customStatement(statement);
            }
            await customStatement(
                'ALTER TABLE guest_profiles ADD COLUMN username TEXT');
            await customStatement(
                'ALTER TABLE guest_profiles ADD COLUMN profile_photo TEXT');
          }
          if (from < 2) {
            await customStatement(guestSchema.firstWhere(
              (statement) =>
                  statement.contains('CREATE TABLE guest_wallet_debits'),
            ));
            await customStatement(
              'CREATE INDEX guest_wallet_debits_wallet_idx ON guest_wallet_debits(wallet_id)',
            );
            await customStatement('''INSERT INTO guest_wallet_debits
              (transaction_id,wallet_id,user_id,amount)
              SELECT id,source_wallet_id,user_id,amount-envelope_amount_used
              FROM guest_transactions WHERE transaction_type='expense'
                AND source_wallet_id IS NOT NULL
                AND amount > envelope_amount_used''');
          }
          if (from < 4) {
            for (final statement in guestNotificationSchema) {
              await customStatement(statement);
            }
          }
          if (from < 3) {
            await customStatement(guestSchema.firstWhere(
              (statement) =>
                  statement.contains('CREATE TABLE guest_wallet_transfers'),
            ));
            await customStatement(
              'CREATE INDEX guest_wallet_transfers_date_idx ON guest_wallet_transfers(occurred_at)',
            );
          }
        },
      );

  static QueryExecutor _openConnection(
          [String fileName = 'drala_guest.sqlite']) =>
      LazyDatabase(() async {
        final directory = await getApplicationDocumentsDirectory();
        return NativeDatabase.createInBackground(
          File('${directory.path}/$fileName'),
        );
      });
}
