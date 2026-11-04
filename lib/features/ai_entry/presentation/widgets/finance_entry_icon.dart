import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:flutter/material.dart';

class FinanceEntryIcon extends StatelessWidget {
  const FinanceEntryIcon({
    required this.emoji,
    required this.iconKey,
    this.colorHex,
    super.key,
  });

  final String emoji;
  final String iconKey;
  final String? colorHex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      child: CategoryIcon(
          iconKey: iconKey,
          emoji: emoji,
          colorHex: colorHex,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
    );
  }
}
