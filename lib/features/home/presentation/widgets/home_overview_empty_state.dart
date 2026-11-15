import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:budgets/core/widgets/empty_state_inline_message.dart';
import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:flutter/material.dart';

class HomeOverviewEmptyState extends StatelessWidget {
  const HomeOverviewEmptyState(
      {required this.message,
      required this.asset,
      required this.actionLabel,
      required this.actionKey,
      required this.onPressed,
      super.key});

  final String Function(String) message;
  final String asset;
  final String actionLabel;
  final Key actionKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: EmptyStatePhrase(
          brief: true,
          illustrationAsset: asset,
          illustrationWidth: AppEmptyStateTheme.compactIllustrationWidth,
          padding: EdgeInsets.zero,
          inlineMessage: EmptyStateInlineMessage(
            key: actionKey,
            message: message,
            actionLabel: actionLabel,
            onPressed: onPressed,
            style: AppEmptyStateTheme.homeLabel(context),
          ),
        ),
      );
}
