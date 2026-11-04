import 'dart:io';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/data/services/offline_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
      'DNS failures mark offline and ordinary requests then fail without more traffic',
      () async {
    final network = OfflineConnectivity();
    addTearDown(network.dispose);
    var requests = 0;
    final client = OfflineHttpClient(network, inner: MockClient((_) async {
      requests++;
      throw const SocketException('Failed host lookup');
    }));
    addTearDown(client.close);
    await expectLater(
        client.get(Uri.parse('https://example.test/rest/v1/wallets')),
        throwsA(isA<SocketException>()));
    expect(network.isOffline, isTrue);
    await expectLater(
        client.get(Uri.parse('https://example.test/rest/v1/wallets')),
        throwsA(isA<http.ClientException>()));
    expect(requests, 1);
    await expectLater(
        client.post(Uri.parse(
            'https://example.test/rest/v1/rpc/offline_sync_revision')),
        throwsA(isA<SocketException>()));
    expect(requests, 2);
  });
  test(
      'authorization and validation errors are not classified as connectivity loss',
      () async {
    for (final status in [400, 401, 403, 409]) {
      final network = OfflineConnectivity();
      final client = OfflineHttpClient(network,
          inner: MockClient((_) async => http.Response('{}', status)));
      await client.get(Uri.parse('https://example.test'));
      expect(network.isOffline, isFalse);
      client.close();
      network.dispose();
    }
  });
}
