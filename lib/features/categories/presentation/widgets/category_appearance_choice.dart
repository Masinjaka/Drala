import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:flutter/material.dart';

class CategoryAppearanceChoice extends StatelessWidget {
  const CategoryAppearanceChoice(
      {required this.label,
      required this.icon,
      required this.onTap,
      super.key});
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
      color: AppFinanceSurfaceTheme.field(context),
      shape: RoundedRectangleBorder(
          borderRadius: AppFinanceSurfaceTheme.cardRadius,
          side: BorderSide(color: AppFinanceSurfaceTheme.border(context))),
      child: InkWell(
          onTap: onTap,
          borderRadius: AppFinanceSurfaceTheme.cardRadius,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                icon,
                const SizedBox(height: 12),
                Text(label,
                    textAlign: TextAlign.center,
                    style: AppFinanceSurfaceTheme.formLabel(context))
              ]))));
}
