import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_envelope_renewal.dart';
import 'package:drift/drift.dart';

class GuestEnvelopeQueries {
  const GuestEnvelopeQueries(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<List<Envelope>> envelopesForMonth(DateTime month) async {
    await GuestEnvelopeRenewal(database, userId).renew(month);
    final rows = await database.customSelect(
      '''SELECT e.*,c.name AS category_name,c.emoji,c.color
         FROM guest_envelopes e
         JOIN guest_categories c ON c.id=e.category_id
         WHERE e.user_id=? AND e.period_month=? ORDER BY e.created_at''',
      variables: [
        Variable.withString(userId),
        Variable.withString(monthKey(month)),
      ],
    ).get();
    return rows.map((row) {
      final value = row.data;
      final amount = value['amount'] as int;
      final remaining = value['remaining_amount'] as int;
      final overspent = value['overspent_amount'] as int;
      return Envelope(
        id: value['id'] as String,
        name: value['name'] as String,
        categoryId: value['category_id'] as String,
        categoryName: value['category_name'] as String,
        emoji: value['emoji'] as String,
        color: value['color'] as String? ?? 'FF9E9E9E',
        amount: amount,
        spent: amount - remaining + overspent,
        currencyCode: value['currency_code'] as String,
        overspentAmount: overspent,
        repeatsMonthly: value['repeats_monthly'] == 1,
      );
    }).toList(growable: false);
  }

  Future<List<EnvelopeCategory>> expenseCategories() async {
    final rows = await database.customSelect(
      '''SELECT id,name,emoji,color FROM guest_categories
         WHERE user_id=? AND transaction_type='expense' ORDER BY name''',
      variables: [Variable.withString(userId)],
    ).get();
    return rows
        .map((row) => EnvelopeCategory.fromJson(row.data))
        .toList(growable: false);
  }

  static String monthKey(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}-01';
}
