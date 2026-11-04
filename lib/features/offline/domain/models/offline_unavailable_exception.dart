class OfflineUnavailableException implements Exception {
  const OfflineUnavailableException({this.needsDownload = false});
  final bool needsDownload;
}
