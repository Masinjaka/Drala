import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:budgets/core/utils/animated_dialog.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
}) async {
  final confirmed = await showAnimatedDialog<bool>(
    context: context,
    builder: (dialogContext) => DeleteConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText ?? context.l10n.delete,
      cancelText: cancelText ?? context.l10n.cancel,
      onConfirm: () => Navigator.of(dialogContext).pop(true),
      onCancel: () => Navigator.of(dialogContext).pop(false),
    ),
  );

  return confirmed ?? false;
}

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    this.confirmKey = const ValueKey('confirm-delete'),
    this.cancelKey = const ValueKey('cancel-delete'),
    this.isLoading = false,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Key confirmKey;
  final Key cancelKey;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 29),
      backgroundColor: colors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton.outlined(
                    key: cancelKey,
                    text: cancelText,
                    onPressed: isLoading ? null : onCancel,
                    height: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    key: confirmKey,
                    text: confirmText,
                    onPressed: isLoading ? null : onConfirm,
                    isLoading: isLoading,
                    height: 40,
                    backgroundColor: AppDangerTheme.fill,
                    foregroundColor: AppDangerTheme.onFill,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
