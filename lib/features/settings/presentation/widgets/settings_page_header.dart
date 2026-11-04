import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_header_metrics.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/core/ui/app_close_button.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_notification_button.dart';
import 'package:flutter/material.dart';

class SettingsPageHeader extends StatelessWidget {
  const SettingsPageHeader({
    required this.title,
    required this.showBackButton,
    required this.onNotifications,
    this.notificationViewModel,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback onNotifications;
  final FinanceNotificationViewModel? notificationViewModel;

  @override
  Widget build(BuildContext context) => Padding(
        padding: AppPageSpacing.insets(context,
            top: AppHeaderMetrics.topPadding, bottom: 12),
        child: Row(children: [
          Expanded(
              child: Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppSettingsTheme.pageTitle(context))),
          const SizedBox(width: AppHeaderMetrics.titleGap),
          SettingsNotificationButton(
              viewModel: notificationViewModel, onPressed: onNotifications),
          if (showBackButton) ...[
            const SizedBox(width: 8),
            AppCloseButton(onPressed: () => Navigator.maybePop(context)),
          ],
        ]),
      );
}
