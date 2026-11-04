import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:flutter/material.dart';

class PasswordVisibilityButton extends StatelessWidget {
  const PasswordVisibilityButton(
      {required this.obscured,
      required this.size,
      required this.onPressed,
      super.key});
  final bool obscured;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: BoxConstraints.tightFor(width: size, height: size),
        style: AppInteractionTheme.withoutPressFeedback(IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
            obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppIconForeground.resolve(
                context,
                Theme.of(context).textTheme.bodyLarge?.color ??
                    Theme.of(context).colorScheme.onSurface)),
      );
}
