import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_empty_state_theme.dart';

class FinanceNotificationsEmptyState extends StatelessWidget {
  const FinanceNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          primary: false,
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: EmptyStatePhrase(
              title: context.l10n.noNotifications,
              brief: true,
              titleStyle: AppEmptyStateTheme.supportingMessage(context),
              illustrationAsset:
                  'assets/illustrations/empty_states/notifications.png',
            ),
          ),
        ),
      ),
    );
  }
}
