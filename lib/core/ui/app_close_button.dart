import 'package:budgets/core/ui/app_header_button_shadow.dart';
import 'package:flutter/material.dart';
import 'app_finance_surface_theme.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({required this.onPressed, super.key});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AppHeaderButtonShadow(
          child: IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        style: AppFinanceSurfaceTheme.headerButton(context),
        icon: const Icon(Icons.close, size: 20),
      ));
}
