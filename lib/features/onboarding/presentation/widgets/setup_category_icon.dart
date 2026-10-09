import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';

class SetupCategoryIcon extends StatelessWidget {
  const SetupCategoryIcon({required this.iconKey, super.key});

  final String iconKey;

  @override
  Widget build(BuildContext context) {
    final appearance = switch (iconKey) {
      'shopping' => ('🛒', AppTheme.onboardingYellow),
      'transport' => ('🚕', AppTheme.onboardingLavender),
      'health' => ('🏥', AppTheme.onboardingBlue),
      'utilities' => ('🛠️', AppTheme.onboardingYellow),
      'food' => ('🍔', AppTheme.onboardingPink),
      'entertainment' => ('🍴', AppTheme.onboardingPalePink),
      'salary' => ('💼', AppTheme.onboardingPalePink),
      'freelance' => ('💰', AppTheme.onboardingPink),
      _ => ('🧾', AppTheme.onboardingPaleBlue),
    };
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dark ? appearance.$2.withValues(alpha: .7) : appearance.$2,
      ),
      child: Text(
        appearance.$1,
        style: AppTextTheme.onboardingEmoji(context, 24),
      ),
    );
  }
}
