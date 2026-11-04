import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/core/currency/exchange_rates_datasource.dart';
import 'package:budgets/features/guest/data/guest_exchange_rate_cache.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';

class OfflineExchangeRatesSource {
  const OfflineExchangeRatesSource(this.account);
  final OfflineAccount? account;
  Future<ExchangeRates?> fetch() async {
    final cache =
        account == null ? null : GuestExchangeRateCache(account!.database);
    if (account?.connectivity.isOffline == true) return cache?.load();
    try {
      final rates = await const ExchangeRatesDataSource().fetchLatest();
      if (rates != null) await cache?.save(rates);
      return rates;
    } catch (error) {
      if (!OfflineConnectivity.isNetworkError(error)) rethrow;
      account?.connectivity.failed(error);
      return cache?.load();
    }
  }
}
