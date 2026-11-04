import 'package:budgets/core/ui/app_setup_theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';

class SetupCategoryIcon extends StatelessWidget {
  const SetupCategoryIcon({required this.iconKey, super.key});

  final String iconKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppSetupTheme.categoryBadge(context, iconKey),
      ),
      child: CategoryIcon(iconKey: iconKey, size: 22),
    );
  }
}
