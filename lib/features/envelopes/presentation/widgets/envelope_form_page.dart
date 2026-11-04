import 'package:budgets/features/transactions/presentation/widgets/transaction_reference_layout.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_field.dart';
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
    this.fundingField,
    this.onDelete,
    super.key,
  });

  final bool editing;
  final Widget? fundingField;
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
  Widget build(BuildContext context) => TransactionReferenceLayout(
        actions: TransactionFormActions(
          saveKey: const Key('save-envelope-button'),
          saving: saving,
          onSave: onSave,
          onCancel: editing ? () => Navigator.pop(context) : null,
        ),
        children: [
          TransactionFormHeader(
            title:
                editing ? context.l10n.editEnvelope : context.l10n.addEnvelope,
            onClose: () => Navigator.pop(context),
            onDelete: saving ? null : onDelete,
            showDelete: editing,
          ),
          const SizedBox(height: 48),
          TransactionAmountField(
            controller: amountController,
            currencyCode: currencyCode,
          ),
          const SizedBox(height: 48),
          TransactionSheetField(
            label: context.l10n.name,
            controller: nameController,
            validator: (value) => FieldValidators.required(context, value,
                message: context.l10n.envelopeNameRequired),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          TransactionCategoryField(
            label: context.l10n.expenseCategory,
            requiredMessage: context.l10n.envelopeCategoryRequired,
            category: category,
            onTap: onCategoryTap,
            onClear: onCategoryClear,
          ),
          if (fundingField != null) ...[
            const SizedBox(height: 24),
            fundingField!,
          ],
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
        ],
      );
}
