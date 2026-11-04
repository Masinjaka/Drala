import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:flutter/material.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';

class HomeOverviewCategoryIcon extends StatelessWidget {
  const HomeOverviewCategoryIcon(
      {this.iconKey = '',
      this.emoji = '',
      this.accent = false,
      this.colorHex,
      super.key});
  final String iconKey;
  final String emoji;
  final bool accent;
  final String? colorHex;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: accent ? 30 : AppCategoryIconTheme.size,
        child: CategoryIcon(
            iconKey: iconKey,
            emoji: emoji,
            size: AppCategoryIconTheme.size,
            colorHex: colorHex));
  }
}
