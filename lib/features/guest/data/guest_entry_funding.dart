import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_envelope_queries.dart';
import 'package:drift/drift.dart';

class GuestEntryFunding {
  const GuestEntryFunding(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<({String? walletId, String? envelopeId, int envelopeUsed})> apply(
    String transactionId,
    ManualEntryInput input,
  ) async {
    var envelopeUsed = 0;
    String? envelopeId;
    if (input.transactionType == 'expense' && input.categoryId != null) {
      final rows = await database.customSelect(
        '''SELECT id,remaining_amount FROM guest_envelopes
           WHERE user_id=? AND category_id=? AND period_month=? LIMIT 1''',
        variables: [
          Variable.withString(userId),
          Variable.withString(input.categoryId!),
          Variable.withString(GuestEnvelopeQueries.monthKey(input.occurredAt)),
        ],
      ).get();
      if (rows.isNotEmpty) {
        envelopeId = rows.single.read<String>('id');
        final remaining = rows.single.read<int>('remaining_amount');
        envelopeUsed = remaining.clamp(0, input.amount);
        final overspent = input.amount - envelopeUsed;
        if (envelopeUsed > 0) {
          await database.customUpdate(
            '''UPDATE guest_envelopes
               SET remaining_amount=remaining_amount-?,updated_at=? WHERE id=?''',
            variables: [
              Variable.withInt(envelopeUsed),
              Variable.withString(DateTime.now().toUtc().toIso8601String()),
              Variable.withString(envelopeId),
            ],
          );
        }
        if (overspent > 0) {
          await database.customUpdate(
            '''UPDATE guest_envelopes
               SET overspent_amount=overspent_amount+?,updated_at=? WHERE id=?''',
            variables: [
              Variable.withInt(overspent),
              Variable.withString(DateTime.now().toUtc().toIso8601String()),
              Variable.withString(envelopeId),
            ],
          );
        }
      }
    }
    final walletAmount = input.amount - envelopeUsed;
    String? walletId;
    if (walletAmount > 0) {
      walletId = await _walletFor(input.sourceWalletId);
      await _adjustWallet(
        walletId,
        input.transactionType == 'income' ? walletAmount : -walletAmount,
      );
      if (input.transactionType == 'expense') {
        await database.customInsert(
          '''INSERT INTO guest_wallet_debits
             (transaction_id,wallet_id,user_id,amount) VALUES(?,?,?,?)''',
          variables: [
            Variable.withString(transactionId),
            Variable.withString(walletId),
            Variable.withString(userId),
            Variable.withInt(walletAmount),
          ],
        );
      }
    }
    return (
      walletId: walletId,
      envelopeId: envelopeId,
      envelopeUsed: envelopeUsed,
    );
  }

  Future<void> reverse(String entryId) async {
    final rows = await database.customSelect(
      '''SELECT amount,transaction_type,source_wallet_id,envelope_id,
                envelope_amount_used FROM guest_transactions
         WHERE id=? AND user_id=?''',
      variables: [Variable.withString(entryId), Variable.withString(userId)],
    ).get();
    if (rows.isEmpty) throw StateError('Transaction not found');
    final row = rows.single;
    final amount = row.read<int>('amount');
    final envelopeUsed = row.read<int>('envelope_amount_used');
    final envelopeId = row.read<String?>('envelope_id');
    final walletId = row.read<String?>('source_wallet_id');
    if (envelopeUsed > 0 && envelopeId != null) {
      await database.customUpdate(
        '''UPDATE guest_envelopes
           SET remaining_amount=remaining_amount+?,updated_at=? WHERE id=?''',
        variables: [
          Variable.withInt(envelopeUsed),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(envelopeId),
        ],
      );
    }
    if (envelopeId != null && amount > envelopeUsed) {
      await database.customUpdate(
        '''UPDATE guest_envelopes
           SET overspent_amount=overspent_amount-?,updated_at=? WHERE id=?''',
        variables: [
          Variable.withInt(amount - envelopeUsed),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(envelopeId),
        ],
      );
    }
    if (row.read<String>('transaction_type') == 'income') {
      if (walletId != null) await _adjustWallet(walletId, -amount);
    } else {
      final debits = await database.customSelect(
        '''SELECT wallet_id,amount FROM guest_wallet_debits
           WHERE transaction_id=? AND user_id=?''',
        variables: [Variable.withString(entryId), Variable.withString(userId)],
      ).get();
      for (final debit in debits) {
        await _adjustWallet(
          debit.read<String>('wallet_id'),
          debit.read<int>('amount'),
        );
      }
    }
    await database.customUpdate(
      'DELETE FROM guest_wallet_debits WHERE transaction_id=? AND user_id=?',
      variables: [Variable.withString(entryId), Variable.withString(userId)],
    );
  }

  Future<String> _walletFor(String? requested) async {
    final rows = await database.customSelect(
      '''SELECT id FROM guest_wallets WHERE user_id=?
         AND (?='' OR id=?) ORDER BY is_default DESC LIMIT 1''',
      variables: [
        Variable.withString(userId),
        Variable.withString(requested ?? ''),
        Variable.withString(requested ?? ''),
      ],
    ).get();
    if (rows.isEmpty) throw StateError('No wallet is available');
    return rows.single.read<String>('id');
  }

  Future<void> _adjustWallet(String id, int amount) async {
    await database.customUpdate(
      '''UPDATE guest_wallets SET balance=balance+?,updated_at=?
         WHERE id=? AND user_id=?''',
      variables: [
        Variable.withInt(amount),
        Variable.withString(DateTime.now().toUtc().toIso8601String()),
        Variable.withString(id),
        Variable.withString(userId),
      ],
    );
  }
}
