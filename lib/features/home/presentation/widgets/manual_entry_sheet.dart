import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_edit_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class ManualEntrySheet extends StatefulWidget {
  const ManualEntrySheet({
    required this.categories,
    required this.targetDate,
    this.currencyState,
    this.entry,
    super.key,
  });

  final Future<List<ManualEntryCategory>> categories;
  final DateTime targetDate;
  final CurrencyState? currencyState;
  final FinanceEntry? entry;

  static Future<ManualEntrySheetResult?> show(
    BuildContext context, {
    required Future<List<ManualEntryCategory>> categories,
    required DateTime targetDate,
    CurrencyState? currencyState,
    FinanceEntry? entry,
  }) =>
      showTransactionFormSheet(
        context,
        builder: (_) => ManualEntrySheet(
          categories: categories,
          targetDate: targetDate,
          currencyState: currencyState,
          entry: entry,
        ),
      );

  @override
  State<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<ManualEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _pages = PageController();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  TransactionType _type = TransactionType.expense;
  Category? _category;
  List<Category> _categories = [];
  bool _loading = true;

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

  void _goToPage(int page) => _pages.animateToPage(page,
      duration: const Duration(milliseconds: 420),
      curve: transactionSheetCurve);

  void _submit() {
    final amount =
        CurrencyAmountInput.toMga(_amount.text, widget.currencyState);
    if (_title.text.trim().isEmpty || amount <= 0) {
      showInfoToast(context, 'Enter a title and a positive amount.');
      return;
    }
    final now = DateTime.now();
    final date = widget.targetDate;
    Navigator.pop(
        context,
        ManualEntrySheetResult.save(ManualEntryInput(
          title: _title.text.trim(),
          description: _description.text.trim(),
          amount: amount,
          transactionType: _type.value,
          categoryId: _category?.id,
          occurredAt: widget.entry?.occurredAt ??
              DateTime(date.year, date.month, date.day, now.hour, now.minute,
                  now.second),
          sourceWalletId: widget.entry?.sourceWalletId,
          useAllWallets: widget.entry?.usedMultipleWallets ?? false,
        )));
  }

  @override
  Widget build(BuildContext context) => TransactionSheetSurface(
        pageController: _pages,
        pages: [
          TransactionDetailEditPage(
            heading: widget.entry == null ? context.l10n.enterManually : null,
            formKey: _formKey,
            amountController: _amount,
            titleController: _title,
            descriptionController: _description,
            currencyCode: widget.currencyState?.code ?? 'MGA',
            type: _type,
            category: _category,
            saving: false,
            onTypeChanged: (value) => setState(() {
              _type = value;
              _category = null;
            }),
            onCategoryTap: () => _goToPage(1),
            onCategoryClear: () => setState(() => _category = null),
            onClose: () => Navigator.pop(context),
            onDelete: widget.entry == null
                ? null
                : () => Navigator.pop(
                    context, const ManualEntrySheetResult.delete()),
            onSave: _submit,
          ),
          TransactionCategoryPage(
            isLoading: _loading,
            categories: _categories
                .where((item) => item.transactionType == _type)
                .toList(),
            selected: _category,
            onSelected: (value) => setState(() => _category = value),
            onBack: () => _goToPage(0),
          ),
        ],
      );
}
