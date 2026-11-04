import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MalagasyCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const MalagasyCupertinoLocalizations();

  @override
  String datePickerMonth(int monthIndex) =>
      DateFormat.MMMM('mg').format(DateTime(2000, monthIndex));

  @override
  String datePickerStandaloneMonth(int monthIndex) =>
      datePickerMonth(monthIndex);

  @override
  String datePickerMediumDate(DateTime date) =>
      DateFormat.MMMEd('mg').format(date);

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.dmy;

  @override
  String get todayLabel => 'Androany';
}
