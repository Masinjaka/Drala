import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:flutter/material.dart';

class HomeEmptyPromptCard extends StatelessWidget {
  const HomeEmptyPromptCard({
    required this.emoji,
    required this.message,
    this.height = 116,
    super.key,
  });

  final String emoji;
  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        boxShadow: AppCardTheme.shadows(context),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28, height: 1)),
          const SizedBox(height: 12),
          Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyle(AppTextRole.caption,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.15),
          ),
        ],
      ),
    );
  }
}
