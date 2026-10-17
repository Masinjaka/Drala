import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class FinanceNotificationsEmptyState extends StatelessWidget {
  const FinanceNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStatePhrase(
      title: context.l10n.noNotifications,
      brief: true,
      illustrationAsset: 'assets/illustrations/empty_states/notifications.png',
    );
  }
}
