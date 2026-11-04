import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:flutter/material.dart';

import 'setup_submit_button.dart';

class SetupSubmitBar extends StatelessWidget {
  const SetupSubmitBar({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.primary = true,
    this.pill = false,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool primary;
  final bool pill;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: AppPageSpacing.insets(context, top: 12, bottom: 30),
          child: SetupSubmitButton(
            isLoading: isLoading,
            onPressed: onPressed,
            text: text,
            primary: primary,
            pill: pill,
          ),
        ),
      );
}
