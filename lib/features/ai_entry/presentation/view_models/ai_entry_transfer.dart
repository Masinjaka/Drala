part of 'ai_entry_view_model.dart';

extension AiEntryTransfers on AiEntryViewModel {
  Future<FinanceEntry> addManualTransfer(ManualTransferInput input) async {
    final repository = _repository;
    if (repository is! ManualTransferRepository) {
      throw UnsupportedError('Manual transfers are unavailable.');
    }
    if (isSubmitting || _isAddingWallet) {
      throw StateError('operation_in_progress');
    }
    _isSubmitting = true;
    _notify();
    try {
      final entry = await (repository as ManualTransferRepository)
          .addManualTransfer(input);
      _hasAnyEntries = true;
      if (DateUtils.isSameDay(_selectedDate, entry.occurredAt)) {
        _entries = _mergeNewEntries([entry], _entries);
      }
      _mergeMonthlyEntries([entry]);
      await refreshBalances();
      return entry;
    } finally {
      _isSubmitting = false;
      _notify();
    }
  }
}
