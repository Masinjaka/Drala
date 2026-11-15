part of 'ai_entry_view_model.dart';

extension AiEntryQuota on AiEntryViewModel {
  Future<void> refreshAiQuota() async {
    final previous = _quota;
    try {
      final quota = await _repository.aiQuota();
      if (_disposed || !identical(previous, _quota)) return;
      _quota = quota;
      _notify();
    } catch (_) {
      // Retain the last known quota while offline.
    }
  }

  Future<T> _waitForSubmission<T>(Future<T> operation) async {
    try {
      return await operation.timeout(_submissionTimeout,
          onTimeout: () => throw const AiEntryException(
              code: 'request_timeout',
              message: 'The AI request took too long. Please try again.',
              status: 504));
    } catch (_) {
      unawaited(refreshAiQuota());
      rethrow;
    }
  }
}
