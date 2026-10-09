import 'package:budgets/core/currency/currency_amount_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = CurrencyAmountInputFormatter();

  group('CurrencyAmountInputFormatter', () {
    test('keeps digits and removes letters and symbols', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(
          text: '12ab 3€4',
          selection: TextSelection.collapsed(offset: 8),
        ),
      );

      expect(result.text, '1,234');
      expect(result.selection.extentOffset, 5);
    });

    test('adds thousands commas while retaining a decimal point', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(
          text: '1234.56',
          selection: TextSelection.collapsed(offset: 7),
        ),
      );

      expect(result.text, '1,234.56');
      expect(result.selection.extentOffset, 8);
    });

    test('keeps the caret beside the digit edited in the middle', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '1,234'),
        const TextEditingValue(
          text: '1,2934',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );
      expect(result.text, '12,934');
      expect(result.selection.extentOffset, 4);
    });

    test('allows the amount to be cleared', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '200'),
        TextEditingValue.empty,
      );

      expect(result.text, isEmpty);
      expect(result.selection.extentOffset, 0);
    });
  });
}
