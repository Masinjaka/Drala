import 'package:budgets/core/forms/submit_validated_form.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'transaction_reference_layout.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_type_selector.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class TransactionDetailEditPage extends StatelessWidget {
  const TransactionDetailEditPage({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.titleController,
    required this.descriptionController,
    required this.currencyCode,
    required this.type,
    required this.category,
    required this.saving,
    required this.onTypeChanged,
    required this.onCategoryTap,
    required this.onCategoryClear,
    required this.onClose,
    this.onDelete,
    this.heading,
    this.typeSelector,
    this.walletField,
    this.animateEntrance = true,
    this.showControls = true,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String currencyCode;
  final TransactionType type;
  final Category? category;
  final bool saving;
  final ValueChanged<TransactionType> onTypeChanged;
  final VoidCallback onCategoryTap;
  final VoidCallback onCategoryClear;
  final VoidCallback onClose;
  final VoidCallback? onDelete;
  final String? heading;
  final Widget? typeSelector;
  final Widget? walletField;
  final bool animateEntrance;
  final bool showControls;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => SubmitValidatedForm(
      formKey: formKey,
      child: TransactionReferenceLayout(
          entranceKey: animateEntrance ? type : null,
          actions: TransactionFormActions(
              saving: saving,
              onSave: onSave,
              onCancel: onDelete == null ? null : onClose),
          children: [
            if (showControls) ...[
              TransactionFormHeader(
                  title: heading ?? context.l10n.editTransaction,
                  onClose: onClose,
                  showTitle: false,
                  showDelete: onDelete != null,
                  onDelete: saving ? null : onDelete),
              const SizedBox(height: 20),
              typeSelector ??
                  TransactionTypeSelector(
                      value: type,
                      incomeLabel: context.l10n.income,
                      expenseLabel: context.l10n.expense,
                      onChanged: onTypeChanged),
              const SizedBox(height: 48),
            ] else
              const SizedBox(height: 28),
            TransactionAmountField(
                controller: amountController, currencyCode: currencyCode),
            const SizedBox(height: 48),
            TransactionSheetField(
                label: context.l10n.title,
                controller: titleController,
                validator: (value) => FieldValidators.required(context, value),
                textInputAction: TextInputAction.next),
            const SizedBox(height: 24),
            TransactionCategoryField(
                label: context.l10n.categories,
                category: category,
                onTap: onCategoryTap,
                onClear: onCategoryClear),
            if (walletField != null) ...[
              const SizedBox(height: 24),
              walletField!
            ],
          ]));
}
