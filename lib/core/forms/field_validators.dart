import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/widgets.dart';

class FieldValidators {
  const FieldValidators._();

  static String? required(BuildContext context, String? value,
          {String? message}) =>
      value == null || value.trim().isEmpty
          ? message ?? context.l10n.fieldRequired
          : null;

  static String? positiveAmount(BuildContext context, String? value) =>
      parseAmountInput(value ?? '') > 0
          ? null
          : context.l10n.positiveAmountRequired;

  static String? balance(BuildContext context, String? value) =>
      parseAmountInput(value ?? '') >= 0
          ? null
          : context.l10n.nonNegativeAmountRequired;
}
