import 'package:budgets/core/theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';

class CategoryBubble extends StatelessWidget {
  const CategoryBubble(
      {required this.kind, required this.size, required this.emoji, super.key});

  final int kind;
  final double size;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final colors = <Color>[
      AppTheme.onboardingBlue,
      AppTheme.onboardingYellow,
      AppTheme.onboardingPink,
      AppTheme.onboardingLavender,
      AppTheme.onboardingPaleBlue,
      AppTheme.onboardingPalePink,
    ];
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark ? colors[kind].withValues(alpha: .68) : colors[kind],
        ),
        child: Center(
          child: CategoryIcon(emoji: emoji, size: size * .55),
        ),
      ),
    );
  }
}
