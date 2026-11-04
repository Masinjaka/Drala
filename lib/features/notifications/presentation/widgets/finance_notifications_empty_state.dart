import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';

class FinanceNotificationsEmptyState extends StatelessWidget {
  const FinanceNotificationsEmptyState({this.onSettings, super.key});
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return EmptyStatePhrase(
      title: context.l10n.noNotifications,
      brief: true,
      action: onSettings == null
          ? null
          : EmptyStateAction(
              label: context.l10n.manageNotifications, onPressed: onSettings!),
      illustrationAsset: 'assets/illustrations/empty_states/notifications.png',
    );
  }
}
