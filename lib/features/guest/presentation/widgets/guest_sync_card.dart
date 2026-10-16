import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
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
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.guestChoiceTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.guestChoiceBody,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: signedIn
                  ? context.l10n.guestSyncNow
                  : context.l10n.authSignIn,
              onPressed: onSignIn,
              isLoading: isLoading,
              height: 44,
              borderRadius: BorderRadius.circular(9),
            ),
          ],
        ),
      ),
    );
  }
}
