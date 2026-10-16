import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsNotificationButton extends StatelessWidget {
  const SettingsNotificationButton({
    required this.onPressed,
    this.viewModel,
    super.key,
  });

  final FinanceNotificationViewModel? viewModel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final model = viewModel;
    if (model == null) return _button(context, 0);
    return ListenableBuilder(
      listenable: model,
      builder: (context, _) => _button(context, model.unreadCount),
    );
  }

  Widget _button(BuildContext context, int unreadCount) => Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: AppSettingsTheme.iconSurface(context),
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: const Key('settings-notification-button'),
              onTap: onPressed,
              child: SizedBox.square(
                dimension: 35,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/settings/notification_bell.svg',
                    colorFilter: ColorFilter.mode(
                      AppSettingsTheme.iconForeground(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                key: const Key('settings-notification-badge'),
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${unreadCount.clamp(0, 9)}',
                  style: AppSettingsTheme.badge(context),
                ),
              ),
            ),
        ],
      );
}
