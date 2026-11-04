import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/currency/currency_amount_input_formatter.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ManualEntryPrimaryFields extends StatelessWidget {
  const ManualEntryPrimaryFields({
    required this.transactionType,
    required this.titleController,
    required this.amountController,
    required this.amountHint,
    required this.amountSuffix,
    super.key,
  });

  final String transactionType;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final String amountHint;
  final String amountSuffix;

  @override
  Widget build(BuildContext context) {
    const labelStyle = AppTextStyle(AppTextRole.body);
    return Column(
      children: [
        CustomTextField(
          title: const Text('Title', style: labelStyle),
          hint: transactionType == 'expense' ? 'Coffee' : 'Salary',
          controller: titleController,
          fieldValidator: (value) => FieldValidators.required(context, value),
          fillColor: Theme.of(context).cardColor,
          fontSize: AppTypography.input,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          title: const Text('Amount', style: labelStyle),
          hint: amountHint,
          suffixText: amountSuffix,
          controller: amountController,
          fieldValidator: (value) =>
              FieldValidators.positiveAmount(context, value),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: const [CurrencyAmountInputFormatter()],
          textStyle: AppTextTheme.amount(
            Theme.of(context).textTheme.bodySmall!,
          ),
          fillColor: Theme.of(context).cardColor,
          fontSize: AppTypography.input,
        ),
      ],
    );
  }
}
