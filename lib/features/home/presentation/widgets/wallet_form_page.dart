import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_reference_layout.dart';
import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_amount_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_default_option.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class WalletFormPage extends StatelessWidget {
  const WalletFormPage({
    this.formKey,
    required this.nameController,
    required this.balanceController,
    required this.onSave,
    required this.setAsDefault,
    required this.onDefaultChanged,
    this.defaultOptionEnabled = true,
    this.currencyState,
    this.editing = false,
    this.onDelete,
    super.key,
  });

  final GlobalKey<FormState>? formKey;
  final TextEditingController nameController;
  final TextEditingController balanceController;
  final CurrencyState? currencyState;
  final VoidCallback onSave;
  final bool setAsDefault;
  final ValueChanged<bool> onDefaultChanged;
  final bool defaultOptionEnabled;
  final bool editing;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final reference = FinanceSheetScope.of(context);
    final actions = TransactionFormActions(
      saving: false,
      onSave: onSave,
      onDelete: onDelete,
      onCancel: editing ? () => Navigator.pop(context) : null,
      saveKey: Key(editing ? 'save-wallet' : 'confirm-add-wallet'),
      deleteKey: const Key('delete-wallet'),
    );
    final fields = <Widget>[
      KeyedSubtree(
        key:
            Key(editing ? 'edit-wallet-sheet-title' : 'add-wallet-sheet-title'),
        child: TransactionFormHeader(
          title: editing ? context.l10n.editWallet : context.l10n.addWallet,
          onClose: () => Navigator.of(context).pop(),
          onDelete: reference ? onDelete : null,
          showDelete: editing,
          deleteKey: const Key('delete-wallet'),
        ),
      ),
      SizedBox(height: reference ? 48 : 37),
      KeyedSubtree(
        key:
            Key(editing ? 'edit-wallet-balance-field' : 'wallet-balance-field'),
        child: TransactionAmountField(
          controller: balanceController,
          validator: (value) => FieldValidators.balance(context, value),
          currencyCode: currencyState?.code ?? 'MGA',
        ),
      ),
      SizedBox(height: reference ? 48 : 25),
      KeyedSubtree(
        key: Key(editing ? 'edit-wallet-name-field' : 'wallet-name-field'),
        child: TransactionSheetField(
          label: context.l10n.walletNameLabel,
          controller: nameController,
          validator: (value) => FieldValidators.required(context, value),
          hint: context.l10n.walletNameHint,
          textInputAction: TextInputAction.done,
        ),
      ),
      SizedBox(height: reference ? 24 : 20),
      WalletDefaultOption(
        value: setAsDefault,
        onChanged: onDefaultChanged,
        enabled: defaultOptionEnabled,
      ),
    ];
    return Form(
      key: formKey,
      child: reference
          ? TransactionReferenceLayout(actions: actions, children: fields)
          : TransactionEditScrollView(
              child: Padding(
                padding: AppPageSpacing.insets(context, top: 12, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [...fields, const SizedBox(height: 24), actions],
                ),
              ),
            ),
    );
  }
}
