import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:flutter/material.dart';

class HomeOverviewEmptyState extends StatelessWidget {
  const HomeOverviewEmptyState(
      {required this.title,
      required this.asset,
      required this.actionLabel,
      required this.actionKey,
      required this.onPressed,
      super.key});
  final String title;
  final String asset;
  final String actionLabel;
  final Key actionKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: EmptyStatePhrase(
          title: title,
          brief: true,
          illustrationAsset: asset,
          illustrationWidth: AppEmptyStateTheme.compactIllustrationWidth,
          titleStyle: AppEmptyStateTheme.homeLabel(context),
          padding: EdgeInsets.zero,
          action: EmptyStateAction(
              key: actionKey, label: actionLabel, onPressed: onPressed),
        ),
      );
}
