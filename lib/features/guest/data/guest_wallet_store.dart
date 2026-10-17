import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/home/domain/errors/wallet_deletion_exception.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/settings/data/services/default_wallet_service.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestWalletStore implements DefaultWalletRepository {
  const GuestWalletStore(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  @override
  Future<List<WalletSummary>> wallets() async {
    final rows = await database.customSelect(
      '''SELECT id, name, balance, currency_code, icon_key, is_default
         FROM guest_wallets WHERE user_id = ? ORDER BY created_at''',
      variables: [Variable.withString(userId)],
    ).get();
    return rows.map((row) => _wallet(row.data)).toList(growable: false);
  }

  Future<WalletSummary> add(AddWalletInput input) async {
    final id = const Uuid().v4();
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await database.customInsert(
        '''INSERT INTO guest_wallets
           (id,user_id,name,balance,currency_code,icon_key,is_default,created_at,updated_at)
           VALUES (?,?,?,?,'MGA','wallet',0,?,?)''',
        variables: [
          Variable.withString(id),
          Variable.withString(userId),
          Variable.withString(input.name),
          Variable.withInt(input.initialBalance),
          Variable.withString(now),
          Variable.withString(now),
        ],
      );
      await GuestSyncJournal(database).record('wallets', id, 'upsert', {
        'id': id,
        'name': input.name,
        'balance': input.initialBalance,
        'currency_code': 'MGA',
        'icon_key': 'wallet',
        'is_default': false,
      });
    });
    if (input.setAsDefault) await setDefault(id);
    return WalletSummary(
      id: id,
      name: input.name,
      balance: input.initialBalance,
      currencyCode: 'MGA',
      iconKey: 'wallet',
      isDefault: input.setAsDefault,
    );
  }

  Future<WalletSummary> update(String id, AddWalletInput input) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await database.customUpdate(
        '''UPDATE guest_wallets SET name = ?, balance = ?, updated_at = ?
           WHERE id = ? AND user_id = ?''',
        variables: [
          Variable.withString(input.name),
          Variable.withInt(input.initialBalance),
          Variable.withString(now),
          Variable.withString(id),
          Variable.withString(userId),
        ],
      );
      await GuestSyncJournal(database).record('wallets', id, 'upsert', {
        'id': id,
        'name': input.name,
        'balance': input.initialBalance,
      });
    });
    if (input.setAsDefault) await setDefault(id);
    final row = await database.customSelect(
      '''SELECT id,name,balance,currency_code,icon_key,is_default
         FROM guest_wallets WHERE id = ? AND user_id = ?''',
      variables: [Variable.withString(id), Variable.withString(userId)],
    ).getSingle();
    return _wallet(row.data);
  }

  Future<void> delete(String id) async {
    final rows = await database.customSelect(
      'SELECT is_default FROM guest_wallets WHERE id = ? AND user_id = ?',
      variables: [Variable.withString(id), Variable.withString(userId)],
    ).get();
    if (rows.isEmpty || rows.single.read<int>('is_default') != 0) {
      throw const WalletDeletionException.inUse();
    }
    final usage = await database.customSelect(
      '''SELECT 1 FROM guest_transactions
         WHERE source_wallet_id = ? AND user_id = ? LIMIT 1''',
      variables: [Variable.withString(id), Variable.withString(userId)],
    ).get();
    if (usage.isNotEmpty) throw const WalletDeletionException.inUse();
    final funding = await database.customSelect(
      '''SELECT 1 FROM guest_envelopes
         WHERE funding_wallet_id = ? AND user_id = ? LIMIT 1''',
      variables: [Variable.withString(id), Variable.withString(userId)],
    ).get();
    if (funding.isNotEmpty) throw const WalletDeletionException.inUse();
    final debits = await database.customSelect(
      '''SELECT 1 FROM guest_wallet_debits
         WHERE wallet_id = ? AND user_id = ? LIMIT 1''',
      variables: [Variable.withString(id), Variable.withString(userId)],
    ).get();
    if (debits.isNotEmpty) throw const WalletDeletionException.inUse();
    final transfers = await database.customSelect(
      '''SELECT 1 FROM guest_wallet_transfers
         WHERE user_id = ? AND (from_wallet_id = ? OR to_wallet_id = ?) LIMIT 1''',
      variables: [
        Variable.withString(userId),
        Variable.withString(id),
        Variable.withString(id),
      ],
    ).get();
    if (transfers.isNotEmpty) throw const WalletDeletionException.inUse();
    await database.transaction(() async {
      await database.customUpdate(
        'DELETE FROM guest_wallets WHERE id = ? AND user_id = ?',
        variables: [Variable.withString(id), Variable.withString(userId)],
      );
      await GuestSyncJournal(database).record('wallets', id, 'delete', {});
    });
  }

  Future<int> totalFunds() async {
    final row = await database.customSelect(
      'SELECT COALESCE(SUM(balance), 0) AS total FROM guest_wallets WHERE user_id = ?',
      variables: [Variable.withString(userId)],
    ).getSingle();
    return row.read<int>('total');
  }

  @override
  Future<void> setDefault(String walletId) async {
    await database.transaction(() async {
      final matches = await database.customSelect(
        'SELECT 1 FROM guest_wallets WHERE id = ? AND user_id = ?',
        variables: [Variable.withString(walletId), Variable.withString(userId)],
      ).get();
      if (matches.isEmpty) throw StateError('Wallet not found.');
      await database.customUpdate(
        '''UPDATE guest_wallets SET is_default = CASE WHEN id = ? THEN 1 ELSE 0 END,
           updated_at = ? WHERE user_id = ?''',
        variables: [
          Variable.withString(walletId),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(userId),
        ],
      );
      await GuestSyncJournal(database).record('wallets', walletId, 'default', {
        'wallet_id': walletId,
      });
    });
  }

  WalletSummary _wallet(Map<String, dynamic> row) => WalletSummary(
        id: row['id'] as String,
        name: row['name'] as String,
        balance: row['balance'] as int,
        currencyCode: row['currency_code'] as String,
        iconKey: row['icon_key'] as String,
        isDefault: row['is_default'] == 1,
      );
}
