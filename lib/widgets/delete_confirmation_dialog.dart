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
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

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
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton.outlined(
                    key: const ValueKey('cancel-delete'),
                    text: cancelText,
                    onPressed: onCancel,
                    height: 40,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    key: const ValueKey('confirm-delete'),
                    text: confirmText,
                    onPressed: onConfirm,
                    height: 40,
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                    borderRadius: BorderRadius.circular(7),
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
