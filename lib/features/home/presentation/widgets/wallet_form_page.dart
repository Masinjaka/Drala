import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletFormPage extends StatelessWidget {
  const WalletFormPage({
    required this.nameController,
    required this.balanceController,
    required this.onSave,
    required this.canSubmit,
    this.currencyState,
    this.editing = false,
    this.onDelete,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController balanceController;
  final CurrencyState? currencyState;
  final VoidCallback onSave;
  final bool canSubmit;
  final bool editing;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return TransactionEditScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          KeyedSubtree(
            key: Key(
                editing ? 'edit-wallet-sheet-title' : 'add-wallet-sheet-title'),
            child: TransactionFormHeader(
              title: editing ? context.l10n.editWallet : context.l10n.addWallet,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 37),
          KeyedSubtree(
            key: Key(
                editing ? 'edit-wallet-balance-field' : 'wallet-balance-field'),
            child: TransactionAmountField(
              controller: balanceController,
              currencyCode: currencyState?.code ?? 'MGA',
            ),
          ),
          const SizedBox(height: 25),
          KeyedSubtree(
            key: Key(editing ? 'edit-wallet-name-field' : 'wallet-name-field'),
            child: TransactionSheetField(
              label: context.l10n.walletNameLabel,
              controller: nameController,
              hint: context.l10n.walletNameHint,
              textInputAction: TextInputAction.done,
            ),
          ),
          const Spacer(),
          TransactionFormActions(
            saving: false,
            onSave: onSave,
            canSave: canSubmit,
            onDelete: onDelete,
            saveKey: Key(editing ? 'save-wallet' : 'confirm-add-wallet'),
            deleteKey: const Key('delete-wallet'),
          ),
        ]),
      ),
    );
  }
}
