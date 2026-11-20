import 'package:budgets/core/ui/app_button_skeleton.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

class GuestSyncCard extends StatelessWidget {
  const GuestSyncCard({
    required this.onSignIn,
    this.signedIn = false,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback onSignIn;
  final bool signedIn;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settingsGuestSyncPrompt,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const AppButtonSkeleton(width: 120, height: 44)
        else
          IntrinsicWidth(
            child: FilledButton(
              key: const Key('guest-settings-sign-in'),
              onPressed: onSignIn,
              style: FilledButton.styleFrom(
                backgroundColor: AppSettingsTheme.signInBackground(context),
                foregroundColor: AppSettingsTheme.signInForeground(context),
                textStyle: theme.textTheme.bodyMedium,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: Text(signedIn
                  ? context.l10n.guestSyncNow
                  : context.l10n.authSignIn),
            ),
          ),
      ],
    );
  }
}
