import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_form_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:flutter/material.dart';

class AddWalletSheet extends StatefulWidget {
  const AddWalletSheet({this.currencyState, super.key});

  final CurrencyState? currencyState;

  static Future<AddWalletInput?> show(BuildContext context,
          {CurrencyState? currencyState}) =>
      showTransactionFormSheet<AddWalletInput>(context,
          builder: (_) => AddWalletSheet(currencyState: currencyState));

  @override
  State<AddWalletSheet> createState() => _AddWalletSheetState();
}

class _AddWalletSheetState extends State<AddWalletSheet> {
  final _pages = PageController();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _balance = TextEditingController();
  bool _setAsDefault = false;

  int? get _initialBalance {
    if (_balance.text.trim().isEmpty) return 0;
    final value =
        CurrencyAmountInput.toMga(_balance.text, widget.currencyState);
    return value >= 0 ? value : null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(AddWalletInput(
        name: _name.text.trim(),
        initialBalance: _initialBalance ?? 0,
        setAsDefault: _setAsDefault));
  }

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    _balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TransactionSheetSurface(
        pageController: _pages,
        pages: [
          WalletFormPage(
            formKey: _formKey,
            nameController: _name,
            balanceController: _balance,
            currencyState: widget.currencyState,
            setAsDefault: _setAsDefault,
            onDefaultChanged: (value) => setState(() => _setAsDefault = value),
            onSave: _submit,
          ),
        ],
      );
}
