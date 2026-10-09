import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_editor_result.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_form_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:flutter/material.dart';

class EditWalletSheet extends StatefulWidget {
  const EditWalletSheet({required this.wallet, this.currencyState, super.key});

  final WalletSummary wallet;
  final CurrencyState? currencyState;

  static Future<WalletEditorResult?> show(BuildContext context,
          {required WalletSummary wallet, CurrencyState? currencyState}) =>
      showTransactionFormSheet<WalletEditorResult>(context,
          builder: (_) =>
              EditWalletSheet(wallet: wallet, currencyState: currencyState));

  @override
  State<EditWalletSheet> createState() => _EditWalletSheetState();
}

class _EditWalletSheetState extends State<EditWalletSheet> {
  final _pages = PageController();
  late final _name = TextEditingController(text: widget.wallet.name);
  late final _balance = TextEditingController(
      text: CurrencyAmountInput.fromStored(widget.wallet.balance,
          widget.wallet.currencyCode, widget.currencyState));
  bool _canSubmit = true;

  @override
  void initState() {
    super.initState();
    _name.addListener(_validate);
    _balance.addListener(_validate);
  }

  void _validate() {
    final valid = _name.text.trim().isNotEmpty && _amount != null;
    if (valid != _canSubmit) setState(() => _canSubmit = valid);
  }

  int? get _amount {
    final value =
        CurrencyAmountInput.toMga(_balance.text, widget.currencyState);
    return value >= 0 ? value : null;
  }

  void _save() {
    if (!_canSubmit) return;
    Navigator.of(context).pop(WalletEditorResult.save(
        AddWalletInput(name: _name.text.trim(), initialBalance: _amount ?? 0)));
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
            editing: true,
            nameController: _name,
            balanceController: _balance,
            currencyState: widget.currencyState,
            canSubmit: _canSubmit,
            onSave: _save,
            onDelete: widget.wallet.isDefault
                ? null
                : () => Navigator.of(context)
                    .pop(const WalletEditorResult.delete()),
          ),
        ],
      );
}
