import 'package:intl/intl.dart';

import 'setup_currency_names.dart';

final _symbolsByCode = <String, String>{
  for (final code in setupCurrencyNames.keys)
    code: NumberFormat.simpleCurrency(name: code).currencySymbol,
};

final _symbolCounts = () {
  final counts = <String, int>{};
  for (final symbol in _symbolsByCode.values) {
    counts.update(symbol, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}();

String setupCurrencySymbol(String code) {
  if (code == 'MGA') return code;
  final symbol = _symbolsByCode[code] ??
      NumberFormat.simpleCurrency(name: code).currencySymbol;
  if (symbol == code || (_symbolCounts[symbol] ?? 0) == 1) return symbol;
  return code;
}
