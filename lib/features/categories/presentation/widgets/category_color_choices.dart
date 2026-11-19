import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'category_color_choice.dart';

class CategoryColorChoices extends StatelessWidget {
  const CategoryColorChoices(
      {required this.color,
      required this.onChanged,
      required this.onCustom,
      super.key});
  final Color color;
  final ValueChanged<Color> onChanged;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      key: const Key('category-color-choices'),
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (final choice in AppCategoryIconTheme.appearanceColors)
          Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: CategoryColorChoice(
                  key: ValueKey('category-color-${choice.toARGB32()}'),
                  color: choice,
                  selected: choice == color,
                  label:
                      '${context.l10n.chooseCategoryColor} #${choice.toARGB32().toRadixString(16).substring(2)}',
                  onTap: () => onChanged(choice))),
        CategoryColorChoice(
            key: const Key('category-color-button'),
            color: color,
            selected: !AppCategoryIconTheme.appearanceColors.contains(color),
            custom: true,
            label: context.l10n.chooseCategoryColor,
            onTap: onCustom),
      ]));
}
