import 'package:budgets/core/ui/app_delete_button.dart';
import 'package:budgets/core/forms/submission_validation_scope.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:flutter/material.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/custom_button.dart';

class TransactionFormActions extends StatelessWidget {
  const TransactionFormActions(
      {super.key,
      required this.saving,
      required this.onSave,
      this.onDelete,
      this.onCancel,
      this.saveKey,
      this.deleteKey,
      this.canSave = true});
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;
  final Key? saveKey;
  final Key? deleteKey;
  final bool canSave;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (FinanceSheetScope.of(context)) {
      final height = 48 +
          (MediaQuery.textScalerOf(context).scale(14) - 14).clamp(0.0, 40.0) *
              2;
      return Row(children: [
        if (onCancel != null) ...[
          Expanded(
              child: CustomButton(
                  key: const Key('cancel-transaction'),
                  text: context.l10n.cancel,
                  onPressed: saving ? null : onCancel,
                  height: height,
                  backgroundColor: AppFinanceSurfaceTheme.field(context),
                  foregroundColor: colors.onSurface)),
          const SizedBox(width: 16)
        ],
        Expanded(
            child: CustomButton(
                key: saveKey ?? const Key('save-transaction'),
                text: context.l10n.save,
                height: height,
                isLoading: saving,
                backgroundColor: AppFinanceSurfaceTheme.action(context),
                foregroundColor: AppFinanceSurfaceTheme.onAction(context),
                onPressed: saving || !canSave
                    ? null
                    : () => SubmissionValidationScope.submit(context, onSave))),
      ]);
    }
    return Row(children: [
      if (onDelete != null) ...[
        AppDeleteButton(
            key: deleteKey ?? const Key('delete-transaction'),
            tooltip: context.l10n.delete,
            onPressed: saving ? null : onDelete),
        const SizedBox(width: 7),
      ],
      Expanded(
        child: CustomButton(
          key: saveKey ?? const ValueKey('save-transaction'),
          text: context.l10n.save,
          height: 40,
          isLoading: saving,
          onPressed: saving || !canSave
              ? null
              : () => SubmissionValidationScope.submit(context, onSave),
        ),
      ),
    ]);
  }
}
