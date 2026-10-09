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
  final _name = TextEditingController();
  final _balance = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_validate);
    _balance.addListener(_validate);
  }

  void _validate() {
    final valid = _name.text.trim().isNotEmpty && _initialBalance != null;
    if (valid != _canSubmit) setState(() => _canSubmit = valid);
  }

  int? get _initialBalance {
    if (_balance.text.trim().isEmpty) return 0;
    final value =
        CurrencyAmountInput.toMga(_balance.text, widget.currencyState);
    return value >= 0 ? value : null;
  }

  void _submit() {
    if (!_canSubmit) return;
    Navigator.of(context).pop(AddWalletInput(
        name: _name.text.trim(), initialBalance: _initialBalance ?? 0));
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
            nameController: _name,
            balanceController: _balance,
            currencyState: widget.currencyState,
            canSubmit: _canSubmit,
            onSave: _submit,
          ),
        ],
      );
}
