import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';
import 'manual_entry_category_field.dart';

class ManualEntryCategoryContent extends StatelessWidget {
  const ManualEntryCategoryContent({
    required this.emoji,
    this.iconKey = '',
    this.colorHex,
    required this.name,
    required this.selected,
    super.key,
  });

  final String emoji;
  final String iconKey;
  final String? colorHex;
  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ManualEntryCategoryField.cardWidth,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              alignment:
                  selected ? const Alignment(0, -0.35) : Alignment.topLeft,
              child: CategoryIcon(
                  iconKey: iconKey,
                  emoji: emoji,
                  size: 22,
                  colorHex: colorHex,
                  backgroundColor: Theme.of(context).cardColor),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              alignment:
                  selected ? Alignment.bottomCenter : Alignment.bottomLeft,
              child: Text(
                name,
                textAlign: selected ? TextAlign.center : TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppCategoryIconTheme.label(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
