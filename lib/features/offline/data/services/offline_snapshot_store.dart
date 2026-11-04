import 'dart:convert';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/offline/data/services/offline_outbox_store.dart';
import 'package:drift/drift.dart';

class OfflineSnapshotStore {
  OfflineSnapshotStore(this.database, this.accountId);
  final GuestDatabase database;
  final String accountId;
  final _columns = <String, Set<String>>{};
  static const tables = {
    'wallets': 'guest_wallets',
    'categories': 'guest_categories',
    'envelopes': 'guest_envelopes',
    'transaction': 'guest_transactions',
    'transaction_wallet_debits': 'guest_wallet_debits',
    'wallet_transfers': 'guest_wallet_transfers',
    'finance_notifications': 'guest_notifications',
    'notification_settings': 'guest_preferences',
    'user': 'guest_profiles',
  };
  Future<void> clearStaging() =>
      database.customStatement('DELETE FROM offline_staging');
  Future<void> stage(String table, List<Map<String, dynamic>> rows) =>
      database.transaction(() async {
        for (final row in rows) {
          if (row['user_id'] != accountId) {
            throw StateError('offline_ownership_violation');
          }
          await database.customStatement(
              'INSERT OR REPLACE INTO offline_staging VALUES(?,?,?)',
              [table, row['_key'], jsonEncode(row)]);
        }
      });
  Future<bool> install(int revision, {bool delta = false}) =>
      database.transaction(() async {
        final outbox = OfflineOutboxStore(database);
        if (await outbox.count() != 0) return false;
        for (final local in delta ? <String>[] : tables.values) {
          if (local == 'guest_preferences') {
            await database.customStatement(
                'DELETE FROM guest_preferences WHERE key=?',
                ['notifications:$accountId']);
          } else {
            await database.customStatement('DELETE FROM $local');
          }
        }
        for (final table in tables.keys) {
          final rows = await database.customSelect(
              'SELECT payload FROM offline_staging WHERE table_name=?',
              variables: [Variable.withString(table)]).get();
          for (final row in rows) {
            await _insert(
                table,
                jsonDecode(row.read<String>('payload'))
                    as Map<String, dynamic>);
          }
        }
        await outbox.setState('revision', '$revision');
        await outbox.setState('hydrated', '1');
        await outbox.setState('pulled_revision', '$revision');
        await clearStaging();
        return true;
      });
  Future<void> _insert(String table, Map<String, dynamic> remote) async {
    final local = tables[table]!;
    if (remote['_deleted'] == true) {
      if (table == 'transaction_wallet_debits') {
        await database.customStatement(
            'DELETE FROM $local WHERE transaction_id=? AND wallet_id=?',
            [remote['transaction_id'], remote['wallet_id']]);
      } else if (table == 'notification_settings') {
        await database.customStatement(
            'DELETE FROM $local WHERE key=?', ['notifications:$accountId']);
      } else {
        await database.customStatement('DELETE FROM $local WHERE id=?',
            [table == 'user' ? accountId : remote['id']]);
      }
      return;
    }
    final columns = _columns[local] ??=
        (await database.customSelect('PRAGMA table_info($local)').get())
            .map((r) => r.read<String>('name'))
            .toSet();
    final row = <String, dynamic>{...remote}..remove('_key');
    final now = DateTime.now().toUtc().toIso8601String();
    if (table == 'user') {
      row['id'] = accountId;
      row['onboarding_complete'] = 1;
      row['created_at'] ??= now;
      row['currency_code'] ??= 'MGA';
      row['language_code'] ??= 'en';
      row['theme_mode'] ??= 'system';
    }
    if (table == 'notification_settings') {
      await database.customStatement(
          'INSERT OR REPLACE INTO guest_preferences(key,value,updated_at) VALUES(?,?,?)',
          ['notifications:$accountId', jsonEncode(row), now]);
      return;
    }
    if (table == 'finance_notifications') row['delivered'] = 1;
    if (table == 'transaction') {
      row['date'] =
          DateTime.parse(row['date'] as String).toUtc().toIso8601String();
    }
    if (table == 'wallet_transfers') {
      row['occurred_at'] = DateTime.parse(row['occurred_at'] as String)
          .toUtc()
          .toIso8601String();
    }
    if (columns.contains('created_at')) row['created_at'] ??= now;
    if (columns.contains('updated_at')) row['updated_at'] ??= now;
    row.removeWhere((key, value) => !columns.contains(key));
    final values = row.values.map((v) => v is bool ? (v ? 1 : 0) : v).toList();
    await database.customStatement(
        'INSERT OR REPLACE INTO $local (${row.keys.join(',')}) VALUES (${row.keys.map((_) => '?').join(',')})',
        values);
  }
}
