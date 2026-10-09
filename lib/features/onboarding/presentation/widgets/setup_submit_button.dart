import 'package:budgets/core/theme.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SetupSubmitButton extends StatelessWidget {
  const SetupSubmitButton(
      {required this.text,
      required this.onPressed,
      this.isLoading = false,
      this.primary = true,
      super.key});
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool primary;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: text,
          height: 44,
          borderRadius: BorderRadius.circular(9),
          backgroundColor: primary
              ? Theme.of(context).colorScheme.primary
              : AppTheme.onboardingChoiceColor(context, selected: true),
          foregroundColor: primary
              ? Theme.of(context).colorScheme.onPrimary
              : AppTheme.onboardingChoiceForeground(context, selected: true),
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      );
}
