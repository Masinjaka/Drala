import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SetupSubmitButton extends StatelessWidget {
  const SetupSubmitButton(
      {required this.text,
      required this.onPressed,
      this.isLoading = false,
      this.primary = true,
      this.pill = false,
      super.key});
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool primary;
  final bool pill;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: CustomButton(
          text: text,
          textStyle: pill ? AppTextTheme.setupAction(context) : null,
          height: 44,
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
