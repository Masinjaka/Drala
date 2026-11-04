import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManualTransferBackend {
  late final HttpServer _server;
  late final SupabaseClient client;
  final requests = <Map<String, dynamic>>[];
  final paths = <String>[];
  final methods = <String>[];

  Future<void> start(DateTime date) async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen((request) async {
      paths.add(request.uri.path);
      methods.add(request.method);
      requests.add(jsonDecode(await utf8.decoder.bind(request).join())
          as Map<String, dynamic>);
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({
        'id': 'submission',
        'entry_type': 'transfer',
        'title': 'Savings',
        'description': 'Savings',
        'amount': 500,
        'date': date.toUtc().toIso8601String(),
        'transaction_type': 'transfer',
        'currency_code': 'MGA',
        'source_wallet_id': 'cash',
      }));
      await request.response.close();
    });
    client = SupabaseClient('http://127.0.0.1:${_server.port}', 'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false));
  }

  Future<void> dispose() async {
    await client.dispose();
    await _server.close(force: true);
  }
}
