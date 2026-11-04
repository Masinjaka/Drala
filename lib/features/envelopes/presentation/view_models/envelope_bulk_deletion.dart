part of 'envelope_view_model.dart';

extension EnvelopeBulkDeletion on EnvelopeViewModel {
  Future<void> deleteMany(List<String> ids) async {
    final repository = _repository;
    if (repository is! BulkEnvelopeRepository) {
      throw UnsupportedError('Bulk envelope deletion is unavailable.');
    }
    _isSaving = true;
    _notifyBulkDeletion();
    try {
      await (repository as BulkEnvelopeRepository).deleteEnvelopes(ids);
      // Responses requested before deletion must not restore deleted cards.
      await Future.wait(_pendingMonths.values
          .toList()
          .map((request) => request.catchError((Object _) {})));
      final removed = ids.toSet();
      _envelopesByMonth.updateAll((_, values) => List.unmodifiable(
          values.where((item) => !removed.contains(item.id))));
    } finally {
      _isSaving = false;
      _notifyBulkDeletion();
    }
  }
}
