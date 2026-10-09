import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class RenewalBackend {
  late final HttpServer _server;
  late final SupabaseClient client;
  String? errorCode = 'PGRST202';
  String missingFunction = 'renew_monthly_envelopes';
  final calls = <String>[];
  final rpcParams = <Map<String, dynamic>>[];

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server.listen((request) async {
      final name = request.uri.pathSegments.last;
      calls.add(name);
      request.response.headers.contentType = ContentType.json;
      if (request.uri.path.contains('/rpc/')) {
        rpcParams.add(jsonDecode(await utf8.decoder.bind(request).join())
            as Map<String, dynamic>);
        if (errorCode != null) {
          request.response.statusCode = 404;
          request.response.write(jsonEncode({
            'code': errorCode,
            'message': errorCode == 'PGRST202'
                ? 'Could not find the function public.$missingFunction(p_month) in the schema cache'
                : 'permission denied for function renew_monthly_envelopes',
          }));
        } else {
          request.response.write('null');
        }
      } else if (name == 'wallets') {
        request.response.write(jsonEncode([
          {'id': 'cash', 'name': 'Cash', 'balance': 800, 'is_default': true}
        ]));
      } else {
        request.response.write('[]');
      }
      await request.response.close();
    });
    client = SupabaseClient('http://127.0.0.1:${_server.port}', 'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false));
    String encode(Map<String, dynamic> value) =>
        base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
    final token = '${encode({'alg': 'HS256'})}.'
        '${encode({'sub': 'test-user', 'exp': 4102444800})}.test';
    await client.auth.setInitialSession(jsonEncode({
      'access_token': token,
      'refresh_token': 'test-refresh',
      'token_type': 'bearer',
      'user': {'id': 'test-user', 'aud': 'authenticated'},
    }));
  }

  Future<void> dispose() async {
    await client.dispose();
    await _server.close(force: true);
  }
}
