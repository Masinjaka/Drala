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
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool isPassword;
  final Map<String, String>? validator;

  @override
  Widget build(BuildContext context) => CustomTextField(
        title: Text(label, style: Theme.of(context).textTheme.labelSmall),
        hint: hint,
        controller: controller,
        isPassword: isPassword,
        keyboardType: isPassword ? TextInputType.visiblePassword : null,
        validator: validator,
        height: 40,
        fontSize: AppTypography.supporting,
        borderRadius: BorderRadius.circular(6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
      );
}
