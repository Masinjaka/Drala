import 'package:flutter/material.dart';
import 'app_finance_surface_theme.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({required this.onPressed, super.key});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        style: AppFinanceSurfaceTheme.headerButton(context),
        icon: const Icon(Icons.close, size: 20),
      );
}
