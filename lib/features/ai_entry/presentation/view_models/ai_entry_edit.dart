part of 'ai_entry_view_model.dart';

extension AiEntryEditing on AiEntryViewModel {
  Future<FinanceEntry> updateFinanceEntry(
    String entryId,
    ManualEntryInput input,
  ) async {
    final original = _entries.where((entry) => entry.id == entryId).firstOrNull;
    if (original != null) {
      _pendingEdits = Map.unmodifiable({
        ..._pendingEdits,
        entryId: FinanceEntryEditChanges.between(original, input),
      });
    }
    _isEditing = true;
    _notify();
    try {
      final entry = await _repository.updateFinanceEntry(entryId, input);
      final previousIndex = _entries.indexWhere((item) => item.id == entryId);
      final updated = _entries.where((item) => item.id != entryId).toList();
      if (DateUtils.isSameDay(_selectedDate, entry.occurredAt)) {
        updated.insert(previousIndex < 0 ? 0 : previousIndex, entry);
      }
      _entries = List.unmodifiable(updated);
      _replaceMonthlyEntry(entryId, entry);
      await refreshBalances();
      return entry;
    } finally {
      _pendingEdits = Map.unmodifiable({..._pendingEdits}..remove(entryId));
      _isEditing = false;
      _notify();
    }
  }

  Future<void> deleteFinanceEntry(String entryId) async {
    _isEditing = true;
    _notify();
    try {
      await _repository.deleteFinanceEntry(entryId);
      _entries = List.unmodifiable(
        _entries.where((entry) => entry.id != entryId),
      );
      _removeMonthlyEntry(entryId);
      await refreshBalances();
    } finally {
      _isEditing = false;
      _notify();
    }
  }
}
