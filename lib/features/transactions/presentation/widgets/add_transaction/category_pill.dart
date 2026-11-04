import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryPill extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9.6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.inverseSurface
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryIcon(
                iconKey: category.iconKey,
                emoji: category.emoji,
                colorHex: category.color,
                size: 18,
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.inverseSurface
                    : Theme.of(context).colorScheme.surface),
            SizedBox(width: 6),
            Text(
              category.name ?? '',
              style: AppTextStyle(AppTextRole.body,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onInverseSurface
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }
}
