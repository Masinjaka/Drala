import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_envelope_queries.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestBudgetAlerts {
  const GuestBudgetAlerts(this.database, this.userId);
  final GuestDatabase database;
  final String userId;

  Future<Map<String, dynamic>?> before(ManualEntryInput input) async {
    if (input.transactionType != 'expense' || input.categoryId == null) {
      return null;
    }
    final rows = await database.customSelect(
      '''SELECT * FROM guest_envelopes WHERE user_id=? AND category_id=?
         AND period_month=?''',
      variables: [
        Variable.withString(userId),
        Variable.withString(input.categoryId!),
        Variable.withString(GuestEnvelopeQueries.monthKey(input.occurredAt))
      ],
    ).get();
    return rows.firstOrNull?.data;
  }

  Future<void> record(
      String entryId, String? envelopeId, Map<String, dynamic>? before) async {
    if (before == null || envelopeId == null) return;
    final settings =
        await GuestPreferenceStore(database, userId).notifications();
    if (!settings.notificationsEnabled || !settings.warningsEnabled) return;
    final row = await database.customSelect(
      'SELECT * FROM guest_envelopes WHERE id=? AND user_id=?',
      variables: [Variable.withString(envelopeId), Variable.withString(userId)],
    ).getSingle();
    final budget = row.read<int>('amount');
    final previousSpent = (before['amount'] as int) -
        (before['remaining_amount'] as int) +
        (before['overspent_amount'] as int);
    final spent = budget -
        row.read<int>('remaining_amount') +
        row.read<int>('overspent_amount');
    final threshold = (settings.warningThreshold.clamp(0, 1) * budget).ceil();
    final type = spent > budget && spent > previousSpent
        ? 'envelope_overspent'
        : spent == budget && previousSpent < budget
            ? 'envelope_limit_reached'
            : spent >= threshold && previousSpent < threshold
                ? 'envelope_near_limit'
                : null;
    if (type == null || budget <= 0) return;
    await database.customInsert(
      '''INSERT OR IGNORE INTO guest_notifications
         (id,user_id,envelope_id,transaction_id,notification_type,envelope_name,
          amount,period_month,created_at) VALUES(?,?,?,?,?,?,?,?,?)''',
      variables: [
        Variable.withString(const Uuid().v4()),
        Variable.withString(userId),
        Variable.withString(envelopeId),
        Variable.withString(entryId),
        Variable.withString(type),
        Variable.withString(row.read<String>('name')),
        Variable.withInt(type == 'envelope_overspent' ? spent - budget : spent),
        Variable.withString(row.read<String>('period_month')),
        Variable.withString(DateTime.now().toUtc().toIso8601String())
      ],
    );
  }
}
