import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestEnvelopeRenewal {
  const GuestEnvelopeRenewal(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<void> renew(DateTime month) async {
    final today = DateTime.now();
    if (month.year != today.year || month.month != today.month) return;
    final key = '${month.year}-${month.month.toString().padLeft(2, '0')}-01';
    await database.transaction(() async {
      final sources = await database.customSelect(
        '''SELECT e.* FROM guest_envelopes e WHERE e.user_id=?
           AND e.repeats_monthly=1 AND e.period_month < ?
           AND NOT EXISTS (
             SELECT 1 FROM guest_envelopes next
             WHERE next.user_id=e.user_id AND next.category_id=e.category_id
               AND next.period_month=?
           ) ORDER BY e.period_month DESC''',
        variables: [
          Variable.withString(userId),
          Variable.withString(key),
          Variable.withString(key),
        ],
      ).get();
      final renewed = <String>{};
      for (final source in sources) {
        final categoryId = source.read<String>('category_id');
        if (!renewed.add(categoryId)) continue;
        final walletId = source.read<String>('funding_wallet_id');
        final amount = source.read<int>('amount');
        final wallet = await database.customSelect(
          'SELECT balance FROM guest_wallets WHERE id=? AND user_id=?',
          variables: [
            Variable.withString(walletId),
            Variable.withString(userId),
          ],
        ).get();
        if (wallet.isEmpty || wallet.single.read<int>('balance') < amount) {
          continue;
        }
        final id = const Uuid().v4();
        final now = DateTime.now().toUtc().toIso8601String();
        await database.customUpdate(
          'UPDATE guest_envelopes SET repeats_monthly=0 WHERE id=?',
          variables: [Variable.withString(source.read<String>('id'))],
        );
        await database.customInsert(
          '''INSERT INTO guest_envelopes
             (id,user_id,category_id,name,amount,remaining_amount,period_month,
              funding_wallet_id,currency_code,repeats_monthly,created_at,updated_at)
             VALUES(?,?,?,?,?,?,?,?,?,?,?,?)''',
          variables: [
            Variable.withString(id),
            Variable.withString(userId),
            Variable.withString(categoryId),
            Variable.withString(source.read<String>('name')),
            Variable.withInt(amount),
            Variable.withInt(amount),
            Variable.withString(key),
            Variable.withString(walletId),
            Variable.withString(source.read<String>('currency_code')),
            Variable.withInt(1),
            Variable.withString(now),
            Variable.withString(now),
          ],
        );
        await database.customUpdate(
          '''UPDATE guest_wallets SET balance=balance-?,updated_at=?
             WHERE id=? AND user_id=?''',
          variables: [
            Variable.withInt(amount),
            Variable.withString(now),
            Variable.withString(walletId),
            Variable.withString(userId),
          ],
        );
        await GuestSyncJournal(database).record('envelopes', id, 'upsert', {
          'id': id,
          'category_id': categoryId,
          'name': source.read<String>('name'),
          'amount': amount,
          'period_month': key,
          'funding_wallet_id': walletId,
          'repeats_monthly': true,
        });
      }
    });
  }
}
