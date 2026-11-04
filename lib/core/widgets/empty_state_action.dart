import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:flutter/material.dart';

class EmptyStateAction extends StatelessWidget {
  const EmptyStateAction(
      {required this.label, required this.onPressed, super.key});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        style: AppEmptyStateTheme.action(context),
        child: Text(label, textAlign: TextAlign.center),
      );
}
