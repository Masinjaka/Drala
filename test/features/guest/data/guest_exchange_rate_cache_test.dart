import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_exchange_rate_cache.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('exchange rates persist for offline guest currency display', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final cache = GuestExchangeRateCache(database);
    expect(await cache.load(), isNull);
    await cache.save(ExchangeRates(
      baseCode: 'MGA',
      rates: const {'MGA': 1, 'USD': 0.00022},
      fetchedAt: DateTime.utc(2026, 10, 13),
    ));
    final loaded = await GuestExchangeRateCache(database).load();
    expect(loaded?.baseCode, 'MGA');
    expect(loaded?.rates['USD'], 0.00022);
    expect(loaded?.fetchedAt, DateTime.utc(2026, 10, 13));
  });
}
