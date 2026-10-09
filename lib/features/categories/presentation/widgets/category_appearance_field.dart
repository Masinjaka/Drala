import 'package:flutter/material.dart';
import 'package:budgets/widgets/custom_button.dart';

class CategoryAppearanceField extends StatelessWidget {
  const CategoryAppearanceField({
    required this.emoji,
    required this.color,
    required this.onEmojiTap,
    required this.onColorTap,
    super.key,
  });

  final String? emoji;
  final Color color;
  final VoidCallback onEmojiTap;
  final VoidCallback onColorTap;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: CustomButton.outlined(
          key: const Key('category-emoji-button'),
          onPressed: onEmojiTap,
          text: emoji?.isNotEmpty == true ? emoji! : '😀',
          textStyle: Theme.of(context).textTheme.titleLarge,
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
