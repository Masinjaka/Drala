import 'dart:async';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/currency/currency_defaults.dart';
import 'package:budgets/core/currency/exchange_rates.dart';
import 'package:budgets/core/currency/exchange_rates_datasource.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/guest/data/guest_exchange_rate_cache.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_provider.g.dart';

@riverpod
Future<ExchangeRates?> exchangeRates(Ref ref) =>
    const ExchangeRatesDataSource().fetchLatest();

@Riverpod(keepAlive: true)
class CurrencyController extends _$CurrencyController {
  @override
  Future<CurrencyState> build() async {
    final guest = ref.read(guestSessionProvider);
    if (guest?.isActive == true) {
      final row = await guest!.database.customSelect(
        'SELECT currency_code FROM guest_profiles WHERE id = ?',
        variables: [Variable.withString(guest.userId)],
      ).getSingle();
      final selected = row.read<String>('currency_code');
      final cache = GuestExchangeRateCache(guest.database);
      var rates = await cache.load();
      if (rates == null && selected != 'MGA') {
        try {
          rates = await _fetchGuestRates(selected, guest);
        } catch (_) {
          // Offline guests can still use the MGA ledger safely.
        }
      } else {
        unawaited(_refreshGuestRates(guest));
      }
      if (rates != null &&
          rates.baseCode != 'MGA' &&
          !rates.rates.containsKey('MGA')) {
        rates = null;
      }
      final base = rates?.baseCode ?? 'MGA';
      final code =
          selected == base || rates?.rates.containsKey(selected) == true
              ? selected
              : 'MGA';
      return CurrencyState(
        code: code,
        preferredCode: selected,
        baseCode: base,
        rates: rates?.rates ?? const {'MGA': 1.0},
        fetchedAt: rates?.fetchedAt,
      );
    }
    final rates = await ref.watch(exchangeRatesProvider.future);
    final user = await ref.watch(userModelProvider.future);
    if (user == null) {
      throw StateError('User profile is not loaded');
    }

    final defaultCode = defaultCurrencyCode();
    final code = user.currencyCode ?? defaultCode;

    if (user.currencyCode == null) {
      await ref.read(userRepositoryProvider).updateCurrencyCode(code);
    }

    final rateMap = Map<String, double>.from(rates?.rates ?? {});
    for (final currencyCode in fallbackCurrencyCodes) {
      rateMap.putIfAbsent(currencyCode, () => 1.0);
    }
    rateMap.putIfAbsent(code, () => 1.0);

    return CurrencyState(
      code: code,
      baseCode: rates?.baseCode ?? 'MGA',
      rates: rateMap,
      fetchedAt: rates?.fetchedAt,
    );
  }

  Future<void> setCurrency(String code) async {
    final current = state.value;
    if (current == null || code == current.preferredCode) return;
    final guest = ref.read(guestSessionProvider);
    if (guest?.isActive == true) {
      var available = current;
      if (code != current.baseCode && !current.rates.containsKey(code)) {
        try {
          final latest = await _fetchGuestRates(code, guest!);
          if (latest != null) {
            available = current.copyWith(
              baseCode: latest.baseCode,
              rates: latest.rates,
              fetchedAt: latest.fetchedAt,
            );
          }
        } catch (_) {
          // Preserve the preference while keeping amounts in MGA.
        }
      }
      await guest!.database.transaction(() async {
        await guest.database.customUpdate(
          'UPDATE guest_profiles SET currency_code = ? WHERE id = ?',
          variables: [
            Variable.withString(code),
            Variable.withString(guest.userId),
          ],
        );
        await GuestSyncJournal(guest.database).record(
          'user',
          guest.userId,
          'upsert',
          {'currency_code': code},
        );
      });
      state = AsyncData(available.copyWith(
        code: code == available.baseCode || available.rates.containsKey(code)
            ? code
            : 'MGA',
        preferredCode: code,
      ));
      return;
    }
    await ref.read(userRepositoryProvider).updateCurrencyCode(code);
    state = AsyncData(current.copyWith(code: code, preferredCode: code));
  }

  Future<bool> retryGuestRates() async {
    final guest = ref.read(guestSessionProvider);
    final current = state.value;
    if (guest?.isActive != true || current == null) return false;
    if (current.preferredCode == current.code) return true;
    try {
      final latest = await _fetchGuestRates(current.preferredCode, guest!);
      if (latest == null) return false;
      state = AsyncData(current.copyWith(
        code: current.preferredCode,
        baseCode: latest.baseCode,
        rates: latest.rates,
        fetchedAt: latest.fetchedAt,
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<ExchangeRates?> _fetchGuestRates(
      String code, GuestSession guest) async {
    final latest = await const ExchangeRatesDataSource()
        .fetchLatest()
        .timeout(const Duration(seconds: 5));
    if (latest == null ||
        (latest.baseCode != 'MGA' && !latest.rates.containsKey('MGA')) ||
        (latest.baseCode != code && !latest.rates.containsKey(code))) {
      return null;
    }
    await GuestExchangeRateCache(guest.database).save(latest);
    return latest;
  }

  Future<void> _refreshGuestRates(GuestSession guest) async {
    try {
      final latest = await const ExchangeRatesDataSource()
          .fetchLatest()
          .timeout(const Duration(seconds: 5));
      if (latest == null ||
          (latest.baseCode != 'MGA' && !latest.rates.containsKey('MGA'))) {
        return;
      }
      await GuestExchangeRateCache(guest.database).save(latest);
      if (!ref.mounted) return;
      final activeGuest = ref.read(guestSessionProvider);
      if (activeGuest?.isActive != true ||
          activeGuest?.userId != guest.userId) {
        return;
      }
      final current = state.value;
      if (current == null) return;
      final preferred = current.preferredCode;
      state = AsyncData(current.copyWith(
        code:
            preferred == latest.baseCode || latest.rates.containsKey(preferred)
                ? preferred
                : 'MGA',
        baseCode: latest.baseCode,
        rates: latest.rates,
        fetchedAt: latest.fetchedAt,
      ));
    } catch (_) {
      // Cached rates are retained when the guest is offline.
    }
  }
}
