import 'package:budgets/core/ui/app_text_theme.dart';
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
      this.focusNode,
      this.onChanged,
      super.key});
  final Widget title;
  final TextEditingController controller;
  final String? hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Map<String, String>? validator;
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
      focusNode: focusNode,
      onChanged: onChanged,
      textStyle: AppTextTheme.authBody(context),
      hintTextStyle: AppTextTheme.authHint(context),
      fontSize: AppTextTheme.authBody(context).fontSize,
      height: AppControlMetrics.height,
      labelSpacing: 6,
      borderRadius: BorderRadius.circular(8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      fillColor: Theme.of(context).colorScheme.surfaceContainer);
}
