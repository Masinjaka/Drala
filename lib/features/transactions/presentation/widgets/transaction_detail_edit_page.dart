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
    required this.onDelete,
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
  final VoidCallback onDelete;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Form(
      key: formKey,
      child: TransactionEditScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  context.l10n.editTransaction,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('close-transaction-sheet'),
                onPressed: onClose,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints.tightFor(width: 32, height: 32),
                icon: const Icon(Icons.close, size: 20),
              ),
            ]),
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
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              IntrinsicWidth(
                child: TextFormField(
                  key: const ValueKey('transaction-amount'),
                  controller: amountController,
                  cursorColor: colors.onSurface,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? '' : null,
                  style: const TextStyle(
                      fontSize: 29, fontWeight: FontWeight.w500, height: 1),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    constraints: BoxConstraints(minWidth: 42, maxWidth: 235),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(currencyCode,
                    style: TextStyle(
                        fontSize: 17, color: Theme.of(context).hintColor)),
              ),
            ]),
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
              label: context.l10n.title,
              controller: descriptionController,
              textInputAction: TextInputAction.done,
            ),
            const Spacer(),
            Row(children: [
              SizedBox(
                width: 40,
                height: 40,
                child: FilledButton(
                  key: const ValueKey('delete-transaction'),
                  onPressed: saving ? null : onDelete,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: colors.surfaceContainer,
                    foregroundColor: colors.error,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Icon(Icons.delete_outline, size: 18),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FilledButton(
                    key: const ValueKey('save-transaction'),
                    onPressed: saving ? null : onSave,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.inverseSurface,
                      foregroundColor: colors.onInverseSurface,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: saving
                        ? SizedBox.square(
                            dimension: 17,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: colors.onInverseSurface))
                        : Text(context.l10n.save,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
