import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

class SettingsLogoutButton extends StatelessWidget {
  const SettingsLogoutButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          key: const Key('settings-logout-button'),
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppSettingsTheme.logout(context),
            side: BorderSide(color: AppSettingsTheme.foreground(context)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: AppSettingsTheme.logoutLabel(context),
          ),
          child: isLoading
              ? SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppSettingsTheme.logout(context),
                  ),
                )
              : Text(label),
        ),
      );
}
