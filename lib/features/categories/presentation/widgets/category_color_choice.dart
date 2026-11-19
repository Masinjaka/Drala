import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:flutter/material.dart';

class CategoryColorChoice extends StatelessWidget {
  const CategoryColorChoice(
      {required this.color,
      required this.selected,
      required this.label,
      required this.onTap,
      this.custom = false,
      super.key});
  final Color color;
  final bool selected;
  final bool custom;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
      selected: selected,
      button: true,
      label: label,
      child: Tooltip(
          message: label,
          child: SizedBox.square(
              dimension: 48,
              child: InkResponse(
                onTap: onTap,
                radius: 24,
                child: Center(
                    child: Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(selected ? 4 : 0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: custom ? null : color,
                            border: Border.all(
                                color: custom
                                    ? Theme.of(context).colorScheme.outline
                                    : color,
                                width: selected ? 3 : 1)),
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: custom ? null : color,
                                border: selected && !custom
                                    ? Border.all(
                                        color:
                                            AppCategoryIconTheme.selectionGap(
                                                context),
                                        width: 3)
                                    : null),
                            child: custom
                                ? Icon(Icons.colorize_rounded,
                                    size: 22,
                                    color: selected
                                        ? color
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface)
                                : null))),
              ))));
}
