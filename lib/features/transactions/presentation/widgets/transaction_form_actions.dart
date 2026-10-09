import 'package:flutter/material.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';

class TransactionFormActions extends StatelessWidget {
  const TransactionFormActions(
      {super.key,
      required this.saving,
      required this.onSave,
      this.onDelete,
      this.saveKey,
      this.deleteKey,
      this.canSave = true});
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback? onDelete;
  final Key? saveKey;
  final Key? deleteKey;
  final bool canSave;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(children: [
      if (onDelete != null) ...[
        CustomButton.icon(
          key: deleteKey ?? const ValueKey('delete-transaction'),
          width: 40,
          height: 40,
          icon: Icons.delete_outline,
          iconSize: 18,
          backgroundColor: colors.surfaceContainer,
          foregroundColor: colors.error,
          borderRadius: BorderRadius.circular(6),
          onPressed: saving ? null : onDelete,
        ),
        const SizedBox(width: 7),
      ],
      Expanded(
        child: CustomButton(
          key: saveKey ?? const ValueKey('save-transaction'),
          text: context.l10n.save,
          height: 40,
          borderRadius: BorderRadius.circular(6),
          isLoading: saving,
          onPressed: saving || !canSave ? null : onSave,
        ),
      ),
    ]);
  }
}
