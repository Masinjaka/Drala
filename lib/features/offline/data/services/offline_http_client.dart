import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';

class OfflineHttpClient extends http.BaseClient {
  OfflineHttpClient(this.connectivity, {http.Client? inner})
      : _inner = inner ?? http.Client();
  final OfflineConnectivity connectivity;
  final http.Client _inner;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final recovery = request.url.path.contains('/rpc/offline_') ||
          request.url.path.endsWith('/rpc/apply_offline_batch') ||
          request.url.path.contains('/auth/v1/token');
      if (connectivity.isOffline && !recovery) {
        throw http.ClientException('Offline mode is active', request.url);
      }
      final response = await _inner.send(request).timeout(Duration(
          seconds: request.url.path.contains('/functions/v1/') ? 55 : 12));
      if ({502, 503, 504, 520, 521, 522, 523, 524}
          .contains(response.statusCode)) {
        connectivity
            .failed(http.ClientException('Server temporarily unavailable'));
      }
      return http.StreamedResponse(response.stream.handleError((Object error) {
        connectivity.failed(error);
        throw error;
      }), response.statusCode,
          contentLength: response.contentLength,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase);
    } catch (error) {
      connectivity.failed(error);
      rethrow;
    }
  }

  @override
  void close() => _inner.close();
}
