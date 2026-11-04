import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/core/ui/category_icons.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon(
      {this.iconKey,
      this.emoji,
      this.size = AppCategoryIconTheme.size,
      this.color,
      this.colorHex,
      this.backgroundColor,
      super.key});
  final String? iconKey;
  final String? emoji;
  final double size;
  final Color? color;
  final String? colorHex;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Icon(
        CategoryIcons.icon(iconKey: iconKey, emoji: emoji),
        size: size,
        color: colorHex != null
            ? AppCategoryIconTheme.color(context, colorHex,
                background: backgroundColor)
            : color ??
                IconTheme.of(context).color ??
                Theme.of(context).colorScheme.onSurface,
      );
}
