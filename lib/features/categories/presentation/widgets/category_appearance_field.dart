import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'category_appearance_choice.dart';
import 'category_icon.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/core/ui/category_icons.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/widgets/custom_button.dart';

class CategoryAppearanceField extends StatelessWidget {
  const CategoryAppearanceField({
    required this.iconKey,
    required this.color,
    required this.onIconTap,
    required this.onColorTap,
    super.key,
  });

  final String iconKey;
  final Color color;
  final VoidCallback onIconTap;
  final VoidCallback onColorTap;

  @override
  Widget build(BuildContext context) {
    if (FinanceSheetScope.of(context))
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: CategoryAppearanceChoice(
                key: const Key('category-icon-button'),
                label: context.l10n.chooseCategoryIcon,
                onTap: onIconTap,
                icon: CategoryIcon(
                    iconKey: iconKey,
                    size: 28,
                    colorHex: color.toARGB32().toRadixString(16)))),
        const SizedBox(width: 16),
        Expanded(
            child: CategoryAppearanceChoice(
                key: const Key('category-color-button'),
                label: context.l10n.chooseCategoryColor,
                onTap: onColorTap,
                icon: Icon(Icons.circle, size: 28, color: color))),
      ]);
    return Row(children: [
      Expanded(
        child: CustomButton.outlined(
          key: const Key('category-icon-button'),
          onPressed: onIconTap,
          icon: CategoryIcons.icon(iconKey: iconKey),
          iconColor: AppCategoryIconTheme.color(
              context, color.toARGB32().toRadixString(16)),
          tooltip: context.l10n.chooseCategoryIcon,
          text: '',
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: CustomButton.outlined(
          key: const Key('category-color-button'),
          onPressed: onColorTap,
          icon: Icons.circle,
          iconColor: color,
          text: '',
        ),
      ),
    ]);
  }
}
