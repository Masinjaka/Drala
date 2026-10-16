import 'dart:io';

import 'package:budgets/features/guest/data/guest_schema.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

class GuestDatabase extends GeneratedDatabase {
  GuestDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  Iterable<TableInfo> get allTables => const [];

  Future<void> clearAllData() => transaction(() async {
        for (final table in const [
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
          for (final statement in guestSchema) {
            await customStatement(statement);
          }
        },
        onUpgrade: (migrator, from, to) async {
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

  static QueryExecutor _openConnection() => LazyDatabase(() async {
        final directory = await getApplicationDocumentsDirectory();
        return NativeDatabase.createInBackground(
          File('${directory.path}/drala_guest.sqlite'),
        );
      });
}
