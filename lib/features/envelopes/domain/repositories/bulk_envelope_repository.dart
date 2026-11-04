abstract interface class BulkEnvelopeRepository {
  Future<void> deleteEnvelopes(List<String> ids);
}
