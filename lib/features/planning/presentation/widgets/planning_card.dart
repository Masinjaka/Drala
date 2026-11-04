import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:flutter/material.dart';

class PlanningCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const PlanningCard({
    super.key,
    required this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: AppCardTheme.shadows(context),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
