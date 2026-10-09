import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PermissionRequestDialog extends StatelessWidget {
  final String title;
  final String message;
  final String allowText;
  final String denyText;
  final VoidCallback onAllow;
  final VoidCallback onDeny;
  final Color? backgroundColor;

  const PermissionRequestDialog({
    super.key,
    this.title = 'Autorisation requise',
    required this.message,
    this.allowText = 'Autoriser',
    this.denyText = 'Refuser',
    required this.onAllow,
    required this.onDeny,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 32),
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  text: denyText,
                  onPressed: onDeny,
                  backgroundColor: theme.colorScheme.surfaceContainerLowest,
                  foregroundColor: theme.colorScheme.onSurface,
                  width: 120,
                  borderColor: Colors.transparent,
                ),
                SizedBox(width: 8),
                CustomButton(
                  backgroundColor: backgroundColor ?? theme.colorScheme.primary,
                  text: allowText,
                  onPressed: onAllow,
                  width: 120,
                  borderColor: Colors.transparent,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
