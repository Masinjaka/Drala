import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/core/currency/exchange_rates_datasource.dart';
import 'package:budgets/features/guest/data/guest_exchange_rate_cache.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';

class GuestExchangeRateLoader {
  const GuestExchangeRateLoader(this.guest);
  final GuestSession guest;
  Future<ExchangeRates?> fetch({String? currencyCode}) async {
    final latest = await const ExchangeRatesDataSource()
        .fetchLatest()
        .timeout(const Duration(seconds: 5));
    if (latest == null ||
        latest.baseCode != 'MGA' && !latest.rates.containsKey('MGA') ||
        currencyCode != null &&
            latest.baseCode != currencyCode &&
            !latest.rates.containsKey(currencyCode)) {
      return null;
    }
    await GuestExchangeRateCache(guest.database).save(latest);
    return latest;
  }
}
