import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_envelope_queries.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/home/domain/errors/wallet_selection_required_exception.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestEnvelopeMutations {
  const GuestEnvelopeMutations(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<void> add({
    required String name,
    required String categoryId,
    required int amount,
    required DateTime month,
    String? walletId,
    bool repeatsMonthly = false,
  }) async {
    if (amount <= 0) throw ArgumentError.value(amount, 'amount');
    final id = const Uuid().v4();
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      final fundingWallet = await _fundingWallet(walletId, amount);
      await database.customInsert(
        '''INSERT INTO guest_envelopes
           (id,user_id,category_id,name,amount,remaining_amount,period_month,
            funding_wallet_id,currency_code,repeats_monthly,created_at,updated_at)
           VALUES(?,?,?,?,?,?,?,?,?,?,?,?)''',
        variables: [
          Variable.withString(id),
          Variable.withString(userId),
          Variable.withString(categoryId),
          Variable.withString(name),
          Variable.withInt(amount),
          Variable.withInt(amount),
          Variable.withString(GuestEnvelopeQueries.monthKey(month)),
          Variable.withString(fundingWallet),
          Variable.withString('MGA'),
          Variable.withInt(repeatsMonthly ? 1 : 0),
          Variable.withString(now),
          Variable.withString(now),
        ],
      );
      await _adjustWallet(fundingWallet, -amount);
      await GuestSyncJournal(database).record('envelopes', id, 'upsert', {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'amount': amount,
        'period_month': GuestEnvelopeQueries.monthKey(month),
        'funding_wallet_id': fundingWallet,
        'repeats_monthly': repeatsMonthly,
      });
    });
  }

  Future<void> update({
    required String id,
    required String name,
    required String categoryId,
    required int amount,
    required bool repeatsMonthly,
  }) async {
    if (amount <= 0) throw ArgumentError.value(amount, 'amount');
    await database.transaction(() async {
      final row = await _envelope(id);
      final oldAmount = row.read<int>('amount');
      final remaining = row.read<int>('remaining_amount');
      final delta = amount - oldAmount;
      if (remaining + delta < 0) {
        throw StateError('Envelope amount cannot be below the amount spent.');
      }
      final walletId = row.read<String>('funding_wallet_id');
      if (delta > 0) await _fundingWallet(walletId, delta);
      await database.customUpdate(
        '''UPDATE guest_envelopes SET name=?,category_id=?,amount=?,
           remaining_amount=remaining_amount+?,repeats_monthly=?,updated_at=?
           WHERE id=? AND user_id=?''',
        variables: [
          Variable.withString(name),
          Variable.withString(categoryId),
          Variable.withInt(amount),
          Variable.withInt(delta),
          Variable.withInt(repeatsMonthly ? 1 : 0),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(id),
          Variable.withString(userId),
        ],
      );
      await _adjustWallet(walletId, -delta);
      await GuestSyncJournal(database).record('envelopes', id, 'upsert', {
        'id': id,
        'name': name,
        'category_id': categoryId,
        'amount': amount,
        'repeats_monthly': repeatsMonthly,
      });
    });
  }

  Future<void> delete(String id) async {
    await database.transaction(() async {
      final row = await _envelope(id);
      final walletId = row.read<String>('funding_wallet_id');
      await database.customInsert(
        '''INSERT INTO guest_wallet_debits
           (transaction_id,wallet_id,user_id,amount)
           SELECT id,?,user_id,envelope_amount_used
           FROM guest_transactions WHERE envelope_id=? AND user_id=?
             AND envelope_amount_used>0
           ON CONFLICT(transaction_id,wallet_id) DO UPDATE SET
             amount=amount+excluded.amount''',
        variables: [
          Variable.withString(walletId),
          Variable.withString(id),
          Variable.withString(userId),
        ],
      );
      await database.customUpdate(
        '''UPDATE guest_transactions SET
           source_wallet_id=COALESCE(source_wallet_id,?),
           envelope_id=NULL,envelope_amount_used=0,updated_at=?
           WHERE envelope_id=? AND user_id=?''',
        variables: [
          Variable.withString(walletId),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(id),
          Variable.withString(userId),
        ],
      );
      await _adjustWallet(
        walletId,
        row.read<int>('remaining_amount'),
      );
      await database.customUpdate(
        'DELETE FROM guest_envelopes WHERE id=? AND user_id=?',
        variables: [Variable.withString(id), Variable.withString(userId)],
      );
      await GuestSyncJournal(database).record('envelopes', id, 'delete', {});
    });
  }

  Future<String> _fundingWallet(String? requested, int amount) async {
    final rows = await database.customSelect(
      '''SELECT id,balance FROM guest_wallets WHERE user_id=?
         AND (?='' OR id=?) ORDER BY is_default DESC LIMIT 1''',
      variables: [
        Variable.withString(userId),
        Variable.withString(requested ?? ''),
        Variable.withString(requested ?? ''),
      ],
    ).get();
    if (rows.isEmpty || rows.single.read<int>('balance') < amount) {
      throw WalletSelectionRequiredException(requiredAmount: amount);
    }
    return rows.single.read<String>('id');
  }

  Future<QueryRow> _envelope(String id) => database.customSelect(
        '''SELECT amount,remaining_amount,funding_wallet_id
           FROM guest_envelopes WHERE id=? AND user_id=?''',
        variables: [Variable.withString(id), Variable.withString(userId)],
      ).getSingle();

  Future<void> _adjustWallet(String id, int delta) async =>
      database.customUpdate(
        '''UPDATE guest_wallets SET balance=balance+?,updated_at=?
           WHERE id=? AND user_id=?''',
        variables: [
          Variable.withInt(delta),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(id),
          Variable.withString(userId),
        ],
      );
}
