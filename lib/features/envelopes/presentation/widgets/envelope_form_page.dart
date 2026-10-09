import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class EnvelopeFormPage extends StatelessWidget {
  const EnvelopeFormPage({
    required this.nameController,
    required this.amountController,
    required this.currencyCode,
    required this.category,
    required this.saving,
    required this.onCategoryTap,
    required this.onCategoryClear,
    required this.onSave,
    required this.repeatsMonthly,
    required this.onRepeatsMonthlyChanged,
    this.editing = false,
    this.onDelete,
    super.key,
  });

  final bool editing;
  final VoidCallback? onDelete;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final String currencyCode;
  final Category? category;
  final bool saving;
  final VoidCallback onCategoryTap;
  final VoidCallback onCategoryClear;
  final VoidCallback onSave;
  final bool repeatsMonthly;
  final ValueChanged<bool> onRepeatsMonthlyChanged;

  @override
  Widget build(BuildContext context) => TransactionEditScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TransactionFormHeader(
              title: editing
                  ? context.l10n.editEnvelope
                  : context.l10n.addEnvelope,
              onClose: () => Navigator.pop(context),
            ),
            const SizedBox(height: 37),
            TransactionAmountField(
              controller: amountController,
              currencyCode: currencyCode,
            ),
            const SizedBox(height: 25),
            TransactionSheetField(
              label: context.l10n.name,
              controller: nameController,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 12),
            TransactionCategoryField(
              label: context.l10n.expenseCategory,
              category: category,
              onTap: onCategoryTap,
              onClear: onCategoryClear,
            ),
            SwitchListTile.adaptive(
              key: const Key('envelope-repeat-monthly'),
              contentPadding: EdgeInsets.zero,
              value: repeatsMonthly,
              onChanged: saving ? null : onRepeatsMonthlyChanged,
              title: Text(context.l10n.repeatEnvelopeMonthly,
                  style: Theme.of(context).textTheme.bodySmall),
              subtitle: Text(context.l10n.repeatEnvelopeMonthlyHelp,
                  style: Theme.of(context).textTheme.labelSmall),
            ),
            const Spacer(),
            TransactionFormActions(
              saveKey: const Key('save-envelope-button'),
              saving: saving,
              onSave: onSave,
              onDelete: onDelete,
            ),
          ]),
        ),
      );
}
