import 'dart:convert';

import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/drift.dart';

class GuestExchangeRateCache {
  const GuestExchangeRateCache(this.database);

  final GuestDatabase database;

  Future<ExchangeRates?> load() async {
    final rows = await database.customSelect(
      'SELECT value FROM guest_preferences WHERE key=?',
      variables: [Variable.withString('exchange_rates')],
    ).get();
    if (rows.isEmpty) return null;
    return ExchangeRates.fromJson(
      Map<String, dynamic>.from(
        jsonDecode(rows.single.read<String>('value')) as Map,
      ),
    );
  }

  Future<void> save(ExchangeRates rates) async {
    await database.customInsert(
      '''INSERT INTO guest_preferences(key,value,updated_at) VALUES(?,?,?)
         ON CONFLICT(key) DO UPDATE SET value=excluded.value,
         updated_at=excluded.updated_at''',
      variables: [
        Variable.withString('exchange_rates'),
        Variable.withString(jsonEncode({
          'base': rates.baseCode,
          'rates': rates.rates,
          'fetched_at': rates.fetchedAt.toUtc().toIso8601String(),
        })),
        Variable.withString(DateTime.now().toUtc().toIso8601String()),
      ],
    );
  }
}
