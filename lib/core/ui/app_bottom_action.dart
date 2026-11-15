import 'app_glass_surface.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'app_finance_surface_theme.dart';

class AppBottomAction extends StatelessWidget {
  const AppBottomAction(
      {required this.label,
      required this.onPressed,
      this.buttonKey,
      super.key});
  final String label;
  final VoidCallback? onPressed;
  final Key? buttonKey;
  @override
  Widget build(BuildContext context) => AppGlassSurface(
      edge: AppGlassEdge.top,
      child: SafeArea(
          child: Padding(
        padding: AppPageSpacing.insets(context, top: 12, bottom: 16),
        child: CustomButton(
            key: buttonKey,
            text: label,
            height: 48,
            backgroundColor: AppFinanceSurfaceTheme.action(context),
            foregroundColor: AppFinanceSurfaceTheme.onAction(context),
            onPressed: onPressed),
      )));
}
