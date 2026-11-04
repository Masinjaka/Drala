import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';

class CategoryIconLabel extends StatelessWidget {
  const CategoryIconLabel(
      {required this.name,
      this.iconKey,
      this.emoji,
      this.style,
      this.color,
      this.colorHex,
      this.backgroundColor,
      super.key});
  final String name;
  final String? iconKey;
  final String? emoji;
  final TextStyle? style;
  final Color? color;
  final String? colorHex;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        CategoryIcon(
            iconKey: iconKey,
            emoji: emoji,
            size: 18,
            color: color,
            colorHex: colorHex,
            backgroundColor: backgroundColor),
        const SizedBox(width: 6),
        Flexible(
            child: Text(name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style ?? Theme.of(context).textTheme.bodyMedium)),
      ]);
}
