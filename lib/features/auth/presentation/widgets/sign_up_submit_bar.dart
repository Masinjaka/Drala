import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class SignUpSubmitBar extends StatelessWidget {
  const SignUpSubmitBar({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
    super.key,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 0, 29, 30),
        child: CustomButton(
          key: const Key('sign-up-submit'),
          text: context.l10n.setupContinue,
          height: 44,
          borderRadius: BorderRadius.circular(9),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          isLoading: isLoading,
          onPressed: isEnabled ? onPressed : null,
        ),
      ),
    );
  }
}
