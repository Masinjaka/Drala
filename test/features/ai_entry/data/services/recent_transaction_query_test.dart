import 'dart:convert';
import 'dart:io';
import 'package:budgets/features/ai_entry/data/services/finance_entry_query_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('recent query bounds the result and sorts history with a user filter',
      () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final requests = <Uri>[];
    server.listen((request) async {
      requests.add(request.uri);
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode([
        {
          'id': 'old',
          'title': 'Older purchase',
          'amount': 100,
          'date': '2023-01-10T12:00:00Z',
          'transaction_type': 'expense',
          'currency_code': 'MGA',
        }
      ]));
      await request.response.close();
    });
    final client = SupabaseClient('http://127.0.0.1:${server.port}', 'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false));
    addTearDown(() async {
      await client.dispose();
      await server.close(force: true);
    });
    final entries =
        await FinanceEntryQueryService(client).recentTransactions('owner');
    expect(entries.single.id, 'old');
    final uri = requests.single;
    expect(uri.path, '/rest/v1/transaction');
    expect(uri.queryParameters['user_id'], 'eq.owner');
    expect(uri.queryParameters['limit'], '3');
    expect(uri.queryParameters['order'], 'date.desc.nullslast,id.desc.nullslast');
    expect(uri.queryParameters.containsKey('date'), isFalse);
  });
}
