import 'transfer_wallet_field.dart';
import 'manual_entry_type_pages.dart';
import 'manual_entry_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_type_selector.dart';
import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_edit_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_transfer_input.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_type_selector.dart';
import 'package:budgets/features/home/presentation/widgets/manual_transfer_form_page.dart';

part 'manual_entry_sheet_submission.dart';
part 'manual_entry_sheet_body.dart';

class ManualEntrySheet extends StatefulWidget {
  const ManualEntrySheet({
    required this.categories,
    required this.targetDate,
    this.currencyState,
    this.entry,
    this.wallets = const [],
    this.allowTransfers = false,
    super.key,
  });

  final Future<List<ManualEntryCategory>> categories;
  final DateTime targetDate;
  final CurrencyState? currencyState;
  final FinanceEntry? entry;
  final List<WalletSummary> wallets;
  final bool allowTransfers;

  static Future<ManualEntrySheetResult?> show(
    BuildContext context, {
    required Future<List<ManualEntryCategory>> categories,
    required DateTime targetDate,
    CurrencyState? currencyState,
    FinanceEntry? entry,
    List<WalletSummary> wallets = const [],
    bool allowTransfers = false,
  }) =>
      showTransactionFormSheet(
        context,
        builder: (_) => ManualEntrySheet(
          categories: categories,
          targetDate: targetDate,
          currencyState: currencyState,
          entry: entry,
          wallets: wallets,
          allowTransfers: allowTransfers,
        ),
      );

  @override
  State<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<ManualEntrySheet> {
  final _formKeys = {
    for (final type in TransactionType.values) type: GlobalKey<FormState>(),
  };
  GlobalKey<FormState> get _formKey => _formKeys[_type]!;
  final _transferFormKey = GlobalKey<FormState>();
  final _pages = PageController();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  TransactionType _type = TransactionType.expense;
  Category? _category;
  List<Category> _categories = [];
  bool _loading = true;
  bool _isTransfer = false;
  String? _transactionWalletId;
  late final String _transferId = const Uuid().v4();
  late String? _fromWalletId =
      widget.wallets.where((w) => w.isDefault).firstOrNull?.id ??
          widget.wallets.firstOrNull?.id;
  late String? _toWalletId =
      widget.wallets.where((w) => w.id != _fromWalletId).firstOrNull?.id;

  void _update(VoidCallback change) => setState(change);

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    if (entry != null) {
      _title.text = entry.title;
      _amount.text = CurrencyAmountInput.fromStored(
        entry.amount,
        entry.currencyCode,
        widget.currencyState,
      );
      _description.text = entry.description;
      _type = TransactionType.fromValue(entry.transactionType) ??
          TransactionType.expense;
      if (entry.categoryId != null) {
        _category = Category(
            id: entry.categoryId,
            name: entry.categoryName,
            emoji: entry.emoji,
            iconKey: entry.iconKey,
            color: entry.categoryColor,
            transactionType: _type);
      }
    }
    widget.categories.then((values) {
      if (!mounted) return;
      setState(() {
        _categories = values
            .map((value) => Category(
                  id: value.id,
                  name: value.name,
                  emoji: value.emoji,
                  iconKey: value.iconKey,
                  color: value.colorHex,
                  transactionType:
                      TransactionType.fromValue(value.transactionType),
                ))
            .toList();
        _loading = false;
      });
    }, onError: (Object error) {
      if (!mounted) return;
      setState(() => _loading = false);
      showErrorToast(context, error);
    });
  }

  @override
  void dispose() {
    _pages.dispose();
    _title.dispose();
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildSheet(context);
}
