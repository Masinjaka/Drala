part of 'finance_entry_query_service.dart';

extension FinanceEntryPageQuery on FinanceEntryQueryService {
  Future<FinanceEntryPage> entriesForDatePage(
    String userId,
    DateTime date, {
    required int limit,
    required int transactionOffset,
    required int transferOffset,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day + 1);
    final rows = await Future.wait([
      _transactionRows(userId, start, end,
          offset: transactionOffset, limit: limit + 1),
      _transferRows(userId, start, end,
          offset: transferOffset, limit: limit + 1),
    ]);
    final candidates = [
      for (final entry in rows[0]) (entry: entry, transfer: false),
      for (final entry in rows[1]) (entry: entry, transfer: true),
    ]..sort((a, b) {
        final byDate = b.entry.occurredAt.compareTo(a.entry.occurredAt);
        return byDate != 0 ? byDate : b.entry.id.compareTo(a.entry.id);
      });
    final page = candidates.take(limit).toList(growable: false);
    return FinanceEntryPage(
      entries: List.unmodifiable(page.map((row) => row.entry)),
      transactionOffset:
          transactionOffset + page.where((row) => !row.transfer).length,
      transferOffset: transferOffset + page.where((row) => row.transfer).length,
      hasMore: candidates.length > limit,
    );
  }
}
