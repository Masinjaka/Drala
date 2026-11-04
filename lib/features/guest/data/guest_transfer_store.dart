import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestTransferStore {
  const GuestTransferStore(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<FinanceEntry> add({
    String? transferId,
    required String fromWalletId,
    required String toWalletId,
    required int amount,
    required DateTime occurredAt,
    String description = '',
  }) async {
    if (amount <= 0) throw StateError('invalid_transfer_amount');
    if (fromWalletId == toWalletId) throw StateError('same_wallet_transfer');
    final id = transferId ?? const Uuid().v4();
    final now = DateTime.now().toUtc().toIso8601String();
    var storedDate = occurredAt;
    await database.transaction(() async {
      final existing = await database.customSelect(
        'SELECT * FROM guest_wallet_transfers WHERE id=?',
        variables: [Variable.withString(id)],
      ).get();
      if (existing.isNotEmpty) {
        final row = existing.single;
        if (row.read<String>('user_id') != userId ||
            row.read<String>('from_wallet_id') != fromWalletId ||
            row.read<String>('to_wallet_id') != toWalletId ||
            row.read<int>('amount') != amount ||
            row.read<String>('description') != description) {
          throw StateError('transfer_id_conflict');
        }
        storedDate = DateTime.parse(row.read<String>('occurred_at')).toLocal();
        return;
      }
      final rows = await database.customSelect(
        '''SELECT id,balance,currency_code FROM guest_wallets
           WHERE user_id=? AND id IN (?,?)''',
        variables: [
          Variable.withString(userId),
          Variable.withString(fromWalletId),
          Variable.withString(toWalletId),
        ],
      ).get();
      if (rows.length != 2) throw StateError('wallet_not_found');
      if (rows.any((row) => row.read<String>('currency_code') != 'MGA')) {
        throw StateError('wallet_currency_mismatch');
      }
      final source = rows.singleWhere(
        (row) => row.read<String>('id') == fromWalletId,
      );
      if (source.read<int>('balance') < amount) {
        throw StateError('The source wallet has insufficient funds.');
      }
      await database.customUpdate(
        '''UPDATE guest_wallets SET balance=balance-?,updated_at=?
           WHERE id=? AND user_id=?''',
        variables: [
          Variable.withInt(amount),
          Variable.withString(now),
          Variable.withString(fromWalletId),
          Variable.withString(userId),
        ],
      );
      await database.customUpdate(
        '''UPDATE guest_wallets SET balance=balance+?,updated_at=?
           WHERE id=? AND user_id=?''',
        variables: [
          Variable.withInt(amount),
          Variable.withString(now),
          Variable.withString(toWalletId),
          Variable.withString(userId),
        ],
      );
      await database.customInsert(
        '''INSERT INTO guest_wallet_transfers
           (id,user_id,from_wallet_id,to_wallet_id,amount,currency_code,
            description,occurred_at,created_at)
           VALUES(?,?,?,?,?,'MGA',?,?,?)''',
        variables: [
          Variable.withString(id),
          Variable.withString(userId),
          Variable.withString(fromWalletId),
          Variable.withString(toWalletId),
          Variable.withInt(amount),
          Variable.withString(description),
          Variable.withString(occurredAt.toUtc().toIso8601String()),
          Variable.withString(now),
        ],
      );
      await GuestSyncJournal(database)
          .record('wallet_transfers', id, 'upsert', {
        'id': id,
        'from_wallet_id': fromWalletId,
        'to_wallet_id': toWalletId,
        'amount': amount,
        'currency_code': 'MGA',
        'description': description,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
      });
    });
    return FinanceEntry(
      id: id,
      title: description.isEmpty ? 'Transfer' : description,
      description: description,
      categoryName: 'Transfer',
      amount: amount.toDouble(),
      occurredAt: storedDate,
      transactionType: 'transfer',
      currencyCode: 'MGA',
      iconKey: 'transfer',
      emoji: '🔄',
      entryType: 'transfer',
      sourceWalletId: fromWalletId,
    );
  }
}
