import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'category_icon.dart';
import 'category_color_choices.dart';

class CategoryAppearanceField extends StatelessWidget {
  const CategoryAppearanceField(
      {required this.iconKey,
      required this.color,
      required this.onIconTap,
      required this.onColorTap,
      required this.onColorChanged,
      super.key});
  final String iconKey;
  final Color color;
  final VoidCallback onIconTap;
  final VoidCallback onColorTap;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) => Column(children: [
        Center(
            child: SizedBox.square(
                dimension: 152,
                child: Stack(alignment: Alignment.center, children: [
                  CategoryIcon(
                      key: const Key('category-appearance-preview'),
                      iconKey: iconKey,
                      size: 104,
                      color: color),
                  PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      child: IconButton(
                          key: const Key('category-icon-button'),
                          tooltip: context.l10n.chooseCategoryIcon,
                          onPressed: onIconTap,
                          style: AppCategoryIconTheme.appearanceEditButton(
                              context),
                          icon: const Icon(Icons.add_rounded, size: 28))),
                ]))),
        const SizedBox(height: 24),
        CategoryColorChoices(
            color: color, onChanged: onColorChanged, onCustom: onColorTap),
      ]);
}
