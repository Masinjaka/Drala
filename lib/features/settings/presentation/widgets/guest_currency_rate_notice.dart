import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class GuestCurrencyRateNotice extends StatelessWidget {
  const GuestCurrencyRateNotice({
    required this.preferred,
    required this.displayed,
    required this.onRetry,
    this.isRetrying = false,
    super.key,
  });

  final String preferred;
  final String displayed;
  final VoidCallback onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline,
                color: AppIconForeground.resolve(
                    context, theme.colorScheme.onSurfaceVariant)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.guestCurrencyRatePending(preferred, displayed),
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: isRetrying ? null : onRetry,
                    child: isRetrying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(context.l10n.setupRetry),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
