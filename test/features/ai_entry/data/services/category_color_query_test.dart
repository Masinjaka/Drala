import 'dart:convert';
import 'dart:io';
import 'package:budgets/features/ai_entry/data/services/finance_entry_query_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  for (final recent in [false, true]) {
    test(
        'signed-in ${recent ? 'home' : 'activity'} query retains saved category colors',
        () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final requests = <Uri>[];
      server.listen((request) async {
        requests.add(request.uri);
        request.response.headers.contentType = ContentType.json;
        request.response
            .write(jsonEncode(request.uri.path.endsWith('/transaction')
                ? [
                    for (final type in ['expense', 'income'])
                      {
                        'id': type,
                        'title': type,
                        'amount': 10,
                        'date': '2026-10-31T10:00:00Z',
                        'transaction_type': type,
                        'categories': {
                          'id': 'category-$type',
                          'name': type,
                          'icon_key': 'food',
                          'color': type == 'expense' ? 'FF8040C0' : 'FF208080'
                        },
                      }
                  ]
                : []));
        await request.response.close();
      });
      final client = SupabaseClient(
          'http://127.0.0.1:${server.port}', 'test-key',
          authOptions: const AuthClientOptions(autoRefreshToken: false));
      addTearDown(() async {
        await client.dispose();
        await server.close(force: true);
      });
      final service = FinanceEntryQueryService(client);
      final entries = recent
          ? await service.recentTransactions('owner')
          : await service.entriesForDate('owner', DateTime(2026, 10, 31));
      expect(entries.map((entry) => entry.categoryColor).toSet(),
          {'FF8040C0', 'FF208080'});
      final query =
          requests.singleWhere((uri) => uri.path.endsWith('/transaction'));
      expect(query.queryParameters['select'],
          contains('categories(id,name,emoji,icon_key,color)'));
    });
  }
}
