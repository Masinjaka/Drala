import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
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
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TransactionEditScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TransactionFormHeader(
              title: heading ?? context.l10n.editTransaction,
              onClose: onClose,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TransactionTypeSelector(
                value: type,
                incomeLabel: context.l10n.income,
                expenseLabel: context.l10n.expense,
                onChanged: onTypeChanged,
              ),
            ),
            const SizedBox(height: 37),
            TransactionAmountField(
                controller: amountController, currencyCode: currencyCode),
            const SizedBox(height: 25),
            TransactionSheetField(
              label: context.l10n.title,
              controller: titleController,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TransactionCategoryField(
              label: context.l10n.categories,
              category: category,
              onTap: onCategoryTap,
              onClear: onCategoryClear,
            ),
            const SizedBox(height: 12),
            TransactionSheetField(
              label: context.l10n.description,
              controller: descriptionController,
              textInputAction: TextInputAction.done,
            ),
            const Spacer(),
            TransactionFormActions(
                saving: saving, onDelete: onDelete, onSave: onSave),
          ]),
        ),
      ),
    );
  }
}
