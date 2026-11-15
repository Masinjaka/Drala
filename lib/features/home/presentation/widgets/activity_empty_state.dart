import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/widgets/empty_state_inline_message.dart';
import 'package:budgets/core/ui/app_empty_state_theme.dart';

class ActivityEmptyState extends StatelessWidget {
  const ActivityEmptyState({this.onAdd, super.key});
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 270),
        child: EmptyStatePhrase(
          title: context.l10n.noActivitiesForDay,
          brief: true,
          titleStyle: AppEmptyStateTheme.supportingMessage(context),
          inlineMessage: onAdd == null
              ? null
              : EmptyStateInlineMessage(
                  message: context.l10n.activityEmptyWithAction,
                  actionLabel: context.l10n.trackYourBudget,
                  onPressed: onAdd!,
                  style: AppEmptyStateTheme.supportingMessage(context),
                ),
          illustrationAsset: 'assets/illustrations/empty_states/activities.png',
        ),
      );
}
