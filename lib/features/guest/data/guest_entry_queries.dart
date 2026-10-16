import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_page.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/drift.dart';

class GuestEntryQueries {
  const GuestEntryQueries(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<List<FinanceEntry>> entriesForDate(DateTime date) =>
      _entries(date, DateTime(date.year, date.month, date.day + 1));

  Future<List<FinanceEntry>> entriesForMonth(DateTime month) => _entries(
      DateTime(month.year, month.month), DateTime(month.year, month.month + 1));

  Future<FinanceEntryPage> entriesForDatePage(
    DateTime date, {
    required int limit,
    required int transactionOffset,
    required int transferOffset,
  }) async {
    final all = await entriesForDate(date);
    final page =
        all.skip(transactionOffset).take(limit).toList(growable: false);
    return FinanceEntryPage(
      entries: page,
      transactionOffset: transactionOffset + page.length,
      transferOffset: transferOffset,
      hasMore: transactionOffset + page.length < all.length,
    );
  }

  Future<bool> hasAnyEntries() async {
    final rows = await database.customSelect(
      '''SELECT 1 FROM guest_transactions WHERE user_id = ?
         UNION SELECT 1 FROM guest_wallet_transfers WHERE user_id = ? LIMIT 1''',
      variables: [Variable.withString(userId), Variable.withString(userId)],
    ).get();
    return rows.isNotEmpty;
  }

  Future<Set<DateTime>> activityDatesForMonth(DateTime month) async {
    final entries = await entriesForMonth(month);
    return entries
        .map((entry) => DateTime(
              entry.occurredAt.year,
              entry.occurredAt.month,
              entry.occurredAt.day,
            ))
        .toSet();
  }

  Future<List<ManualEntryCategory>> categories() async {
    final rows = await database.customSelect(
      '''SELECT id,name,emoji,color,transaction_type
         FROM guest_categories WHERE user_id = ? ORDER BY name''',
      variables: [Variable.withString(userId)],
    ).get();
    return rows
        .map((row) => ManualEntryCategory.fromJson(row.data))
        .toList(growable: false);
  }

  Future<List<FinanceEntry>> _entries(DateTime start, DateTime end) async {
    final rows = await database.customSelect(
      '''SELECT t.*, c.name AS category_name, c.emoji AS category_emoji,
                c.icon_key AS category_icon, e.name AS envelope_name
         FROM guest_transactions t
         LEFT JOIN guest_categories c ON c.id = t.category_id
         LEFT JOIN guest_envelopes e ON e.id = t.envelope_id
         WHERE t.user_id = ? AND t.date >= ? AND t.date < ?
         ORDER BY t.date DESC, t.created_at DESC''',
      variables: [
        Variable.withString(userId),
        Variable.withString(start.toUtc().toIso8601String()),
        Variable.withString(end.toUtc().toIso8601String()),
      ],
    ).get();
    final transfers = await database.customSelect(
      '''SELECT * FROM guest_wallet_transfers
         WHERE user_id=? AND occurred_at>=? AND occurred_at<?''',
      variables: [
        Variable.withString(userId),
        Variable.withString(start.toUtc().toIso8601String()),
        Variable.withString(end.toUtc().toIso8601String()),
      ],
    ).get();
    final entries = [
      ...rows.map((row) => fromRow(row.data)),
      ...transfers.map((row) => _transfer(row.data)),
    ]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return entries;
  }

  FinanceEntry _transfer(Map<String, dynamic> row) => FinanceEntry(
        id: row['id'] as String,
        title: (row['description'] as String).isEmpty
            ? 'Transfer'
            : row['description'] as String,
        description: row['description'] as String,
        categoryName: 'Transfer',
        amount: (row['amount'] as num).toDouble(),
        occurredAt: DateTime.parse(row['occurred_at'] as String).toLocal(),
        transactionType: 'transfer',
        currencyCode: row['currency_code'] as String,
        iconKey: 'transfer',
        emoji: '🔄',
        entryType: 'transfer',
        sourceWalletId: row['from_wallet_id'] as String,
      );

  FinanceEntry fromRow(Map<String, dynamic> row) => FinanceEntry(
        id: row['id'] as String,
        title: row['title'] as String,
        description: row['description'] as String,
        categoryName: row['category_name'] as String? ?? 'Other',
        amount: (row['amount'] as num).toDouble(),
        occurredAt: DateTime.parse(row['date'] as String).toLocal(),
        transactionType: row['transaction_type'] as String,
        currencyCode: row['currency_code'] as String,
        iconKey: row['category_icon'] as String? ?? 'other',
        emoji: row['category_emoji'] as String? ?? '🧾',
        entryType: row['entry_type'] as String,
        categoryId: row['category_id'] as String?,
        sourceWalletId: row['source_wallet_id'] as String?,
        envelopeName: row['envelope_name'] as String?,
      );
}
