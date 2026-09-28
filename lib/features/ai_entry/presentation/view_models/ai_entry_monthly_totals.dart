part of 'ai_entry_view_model.dart';

extension AiEntryMonthlyTotals on AiEntryViewModel {
  num _monthlyTotal(bool Function(FinanceEntry entry) matches) =>
      _monthlyEntries
          .where(matches)
          .fold<num>(0, (total, entry) => total + entry.amount);

  void _mergeMonthlyEntries(List<FinanceEntry> additions) {
    final currentMonthAdditions = additions.where(_isInCurrentMonth).toList();
    if (currentMonthAdditions.isEmpty) return;
    final addedIds = currentMonthAdditions.map((entry) => entry.id).toSet();
    _monthlyEntries = List.unmodifiable([
      ...currentMonthAdditions,
      ..._monthlyEntries.where((entry) => !addedIds.contains(entry.id)),
    ]);
  }

  void _replaceMonthlyEntry(String entryId, FinanceEntry replacement) {
    _monthlyEntries = List.unmodifiable([
      if (_isInCurrentMonth(replacement)) replacement,
      ..._monthlyEntries.where((entry) => entry.id != entryId),
    ]);
  }

  void _removeMonthlyEntry(String entryId) {
    _monthlyEntries = List.unmodifiable(
      _monthlyEntries.where((entry) => entry.id != entryId),
    );
  }

  bool _isInCurrentMonth(FinanceEntry entry) {
    final month = _monthlyEntriesMonth;
    return month != null &&
        entry.occurredAt.year == month.year &&
        entry.occurredAt.month == month.month;
  }
}
