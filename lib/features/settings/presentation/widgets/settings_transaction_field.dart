import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SettingsTransactionField extends StatelessWidget {
  const SettingsTransactionField({
    required this.label,
    required this.controller,
    this.hint,
    this.isPassword = false,
    this.validator,
    this.fieldValidator,
    this.fillColor,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final Map<String, String>? validator;
  final FormFieldValidator<String>? fieldValidator;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) => CustomTextField(
        title: Text(label,
            style: FinanceSheetScope.of(context)
                ? AppFinanceSurfaceTheme.formLabel(context)
                : Theme.of(context).textTheme.bodyMedium),
        hint: hint,
        controller: controller,
        isPassword: isPassword,
        keyboardType: isPassword ? TextInputType.visiblePassword : null,
        validator: validator,
        fieldValidator: fieldValidator,
        height: 48,
        fontSize: AppTypography.input,
        borderRadius: BorderRadius.circular(24),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        fillColor:
            fillColor ?? Theme.of(context).colorScheme.surfaceContainerLowest,
      );
}
