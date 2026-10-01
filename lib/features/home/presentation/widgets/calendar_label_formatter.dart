import 'package:intl/intl.dart';

class CalendarLabelFormatter {
  const CalendarLabelFormatter._();

  static String monthYear(DateTime date, String locale) =>
      _capitalize(DateFormat.yMMMM(locale).format(date), locale);

  static String weekday(DateTime date, String? locale) {
    final effectiveLocale = locale ?? Intl.getCurrentLocale();
    return _capitalize(
      DateFormat.E(effectiveLocale).format(date),
      effectiveLocale,
    );
  }

  static String _capitalize(String value, String locale) =>
      toBeginningOfSentenceCase(value, locale) ?? value;
}
