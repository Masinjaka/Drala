import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {required this.title,
      required this.controller,
      this.hint,
      this.isPassword = false,
      this.keyboardType,
      this.validator,
      this.fieldValidator,
      this.focusNode,
      this.onChanged,
      super.key});
  final Widget title;
  final TextEditingController controller;
  final String? hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Map<String, String>? validator;
  final FormFieldValidator<String>? fieldValidator;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) => CustomTextField(
      title: title,
      controller: controller,
      hint: hint,
      isPassword: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      fieldValidator: fieldValidator,
      focusNode: focusNode,
      onChanged: onChanged,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      hintTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
      height: AppControlMetrics.height,
      labelSpacing: 6,
      borderRadius: AppButtonTheme.borderRadius,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      fillColor: Theme.of(context).colorScheme.surfaceContainer);
}
