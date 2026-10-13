import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
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
  Widget build(BuildContext context) => SizedBox(
        height: 67,
        child: Stack(
          children: [
            Positioned.fill(
              top: 20,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  title,
                  style: AppSettingsTheme.pageTitle(context),
                ),
              ),
            ),
            if (showBackButton)
              Positioned(
                left: 24,
                top: 15,
                child: OutlinedSquareButton(
                  icon: Icons.arrow_back_rounded,
                  visualSize: 35,
                  iconSize: 20,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            Positioned(
              right: 25,
              top: 22,
              child: SettingsNotificationButton(
                viewModel: notificationViewModel,
                onPressed: onNotifications,
              ),
            ),
          ],
        ),
      );
}
