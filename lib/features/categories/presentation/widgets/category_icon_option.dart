import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';

class CategoryIconOption extends StatelessWidget {
  const CategoryIconOption(
      {required this.iconKey,
      required this.label,
      required this.selected,
      required this.onTap,
      this.colorHex,
      super.key});
  final String iconKey;
  final String? colorHex;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Tooltip(
          message: label,
          child: AppCardSurface(
            color: selected
                ? colors.secondaryContainer
                : colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('category-icon-$iconKey'),
              onTap: onTap,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CategoryIcon(
                            iconKey: iconKey,
                            colorHex: colorHex,
                            backgroundColor: selected
                                ? colors.secondaryContainer
                                : colors.surfaceContainerLowest,
                            size: 26,
                            color: selected
                                ? colors.onSecondaryContainer
                                : colors.onSurface),
                        const SizedBox(height: 8),
                        Text(label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppCategoryIconTheme.label(context,
                                selected: selected)),
                      ])),
            ),
          )),
    );
  }
}
