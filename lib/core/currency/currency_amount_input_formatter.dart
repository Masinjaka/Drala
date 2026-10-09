import 'package:flutter/services.dart';

class CurrencyAmountInputFormatter extends TextInputFormatter {
  const CurrencyAmountInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    final sanitized = _sanitize(newValue.text);
    final text = _group(sanitized);
    final baseOffset =
        _selectionOffset(newValue.text, newValue.selection.baseOffset, text);
    final extentOffset =
        _selectionOffset(newValue.text, newValue.selection.extentOffset, text);
    return TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      ),
    );
  }

  String _sanitize(String value) {
    final result = StringBuffer();
    var hasDecimal = false;
    for (final character in value.split('')) {
      if (_isDigit(character)) {
        result.write(character);
      } else if (!hasDecimal && character == '.') {
        result.write('.');
        hasDecimal = true;
      }
    }
    return result.toString();
  }

  String _group(String value) {
    final decimal = value.indexOf('.');
    final integer = decimal < 0 ? value : value.substring(0, decimal);
    final result = StringBuffer();
    for (var index = 0; index < integer.length; index++) {
      if (index > 0 && (integer.length - index) % 3 == 0) result.write(',');
      result.write(integer[index]);
    }
    if (decimal >= 0) result.write(value.substring(decimal));
    return result.toString();
  }

  int _selectionOffset(String value, int offset, String formatted) {
    if (offset < 0) return 0;
    var remaining = _sanitize(
      value.substring(0, offset.clamp(0, value.length)),
    ).length;
    if (remaining == 0) return 0;
    for (var index = 0; index < formatted.length; index++) {
      if (formatted[index] != ',') remaining--;
      if (remaining == 0) return index + 1;
    }
    return formatted.length;
  }

  bool _isDigit(String character) {
    final codeUnit = character.codeUnitAt(0);
    return codeUnit >= 48 && codeUnit <= 57;
  }
}
