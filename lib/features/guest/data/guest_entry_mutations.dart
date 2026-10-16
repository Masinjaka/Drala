import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_entry_funding.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestEntryMutations {
  const GuestEntryMutations(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<FinanceEntry> add(ManualEntryInput input) async {
    final id = const Uuid().v4();
    return _write(id, input, replacing: false);
  }

  Future<FinanceEntry> update(String id, ManualEntryInput input) =>
      _write(id, input, replacing: true);

  Future<FinanceEntry> _write(
    String id,
    ManualEntryInput input, {
    required bool replacing,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      final funding = GuestEntryFunding(database, userId);
      if (replacing) await funding.reverse(id);
      final applied = await funding.apply(id, input);
      if (replacing) {
        await database.customUpdate(
          '''UPDATE guest_transactions SET title=?,description=?,amount=?,
             transaction_type=?,date=?,category_id=?,source_wallet_id=?,
             envelope_id=?,envelope_amount_used=?,updated_at=?
             WHERE id=? AND user_id=?''',
          variables: [
            Variable.withString(input.title),
            Variable.withString(input.description),
            Variable.withInt(input.amount),
            Variable.withString(input.transactionType),
            Variable.withString(input.occurredAt.toUtc().toIso8601String()),
            Variable<String>(input.categoryId),
            Variable<String>(applied.walletId),
            Variable<String>(applied.envelopeId),
            Variable.withInt(applied.envelopeUsed),
            Variable.withString(now),
            Variable.withString(id),
            Variable.withString(userId),
          ],
        );
      } else {
        await database.customInsert(
          '''INSERT INTO guest_transactions
             (id,user_id,title,description,amount,transaction_type,date,
              category_id,source_wallet_id,envelope_id,envelope_amount_used,
              created_at,updated_at)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)''',
          variables: [
            Variable.withString(id),
            Variable.withString(userId),
            Variable.withString(input.title),
            Variable.withString(input.description),
            Variable.withInt(input.amount),
            Variable.withString(input.transactionType),
            Variable.withString(input.occurredAt.toUtc().toIso8601String()),
            Variable<String>(input.categoryId),
            Variable<String>(applied.walletId),
            Variable<String>(applied.envelopeId),
            Variable.withInt(applied.envelopeUsed),
            Variable.withString(now),
            Variable.withString(now),
          ],
        );
      }
      await GuestSyncJournal(database).record('transaction', id, 'upsert', {
        'id': id,
        'title': input.title,
        'description': input.description,
        'amount': input.amount,
        'transaction_type': input.transactionType,
        'date': input.occurredAt.toUtc().toIso8601String(),
        'category_id': input.categoryId,
        'source_wallet_id': applied.walletId,
        'envelope_id': applied.envelopeId,
        'envelope_amount_used': applied.envelopeUsed,
        'currency_code': 'MGA',
      });
    });
    return _read(id);
  }

  Future<void> delete(String id) async {
    await database.transaction(() async {
      await GuestEntryFunding(database, userId).reverse(id);
      await database.customUpdate(
        'DELETE FROM guest_transactions WHERE id=? AND user_id=?',
        variables: [Variable.withString(id), Variable.withString(userId)],
      );
      await GuestSyncJournal(database).record('transaction', id, 'delete', {});
    });
  }

  Future<FinanceEntry> _read(String id) async {
    final row = await database.customSelect(
      '''SELECT t.*, c.name AS category_name,c.emoji AS category_emoji,
                c.icon_key AS category_icon,e.name AS envelope_name
         FROM guest_transactions t
         LEFT JOIN guest_categories c ON c.id=t.category_id
         LEFT JOIN guest_envelopes e ON e.id=t.envelope_id
         WHERE t.id=? AND t.user_id=?''',
      variables: [Variable.withString(id), Variable.withString(userId)],
    ).getSingle();
    return GuestEntryQueries(database, userId).fromRow(row.data);
  }
}
