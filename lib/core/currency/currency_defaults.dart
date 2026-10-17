import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

const fallbackCurrencyCodes = <String>{
  'MGA',
  'USD',
  'EUR',
  'GBP',
  'CAD',
  'AUD',
  'JPY',
  'CNY',
  'CHF',
  'ZAR',
  'KES',
};

String defaultCurrencyCode() {
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  final formatter = NumberFormat.simpleCurrency(locale: locale.toString());
  final currencyName = formatter.currencyName;
  return currencyName == null || currencyName.isEmpty ? 'MGA' : currencyName;
}
