import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/home/domain/models/manual_entry_sheet_result.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_edit_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:flutter/material.dart';

class FinanceEntryDetailSheet extends StatefulWidget {
  const FinanceEntryDetailSheet({
    required this.entry,
    required this.categories,
    this.currencyState,
    super.key,
  });

  final FinanceEntry entry;
  final Future<List<ManualEntryCategory>> categories;
  final CurrencyState? currencyState;

  @override
  State<FinanceEntryDetailSheet> createState() =>
      _FinanceEntryDetailSheetState();
}

class _FinanceEntryDetailSheetState extends State<FinanceEntryDetailSheet> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  late final TextEditingController _amountController;
  late final double _initialDisplayAmount;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TransactionType _type;
  Category? _category;
  List<Category> _categories = const [];

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _type = TransactionType.fromValue(entry.transactionType) ??
        TransactionType.expense;
    _category = Category(
      id: entry.categoryId,
      name: entry.categoryName,
      emoji: entry.emoji,
      transactionType: _type,
    );
    _amountController = TextEditingController(
      text: CurrencyAmountInput.fromStored(
        entry.amount,
        entry.currencyCode,
        widget.currencyState,
      ),
    );
    _titleController = TextEditingController(text: entry.title);
    _initialDisplayAmount = parseAmountInput(_amountController.text);
    _descriptionController = TextEditingController(text: entry.description);
    widget.categories.then(_setCategories, onError: (_) {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final available = _categories
        .where((category) => category.transactionType == _type)
        .toList();
    final selected = _category;
    if (selected != null &&
        !available.any((category) => category.id == selected.id)) {
      available.insert(0, selected);
    }
    return TransactionSheetSurface(
      pageController: _pageController,
      pages: [
        TransactionDetailEditPage(
          formKey: _formKey,
          amountController: _amountController,
          titleController: _titleController,
          descriptionController: _descriptionController,
          currencyCode: widget.currencyState?.code ?? widget.entry.currencyCode,
          type: _type,
          category: _category,
          saving: false,
          onTypeChanged: _changeType,
          onCategoryTap: () => _goToPage(1),
          onCategoryClear: () => setState(() => _category = null),
          onClose: () => Navigator.pop(context),
          onDelete: () => Navigator.pop(
            context,
            const ManualEntrySheetResult.delete(),
          ),
          onSave: _submit,
        ),
        TransactionCategoryPage(
          categories: available,
          selected: _category,
          onSelected: (value) => setState(() => _category = value),
          onBack: () => _goToPage(0),
        ),
      ],
    );
  }

  void _setCategories(List<ManualEntryCategory> values) {
    if (!mounted) return;
    setState(() {
      _categories = values.map((category) {
        return Category(
          id: category.id,
          name: category.name,
          emoji: category.emoji,
          color: category.colorHex,
          transactionType: TransactionType.fromValue(category.transactionType),
        );
      }).toList(growable: false);
      for (final category in _categories) {
        if (category.id == _category?.id) _category = category;
      }
    });
  }

  void _goToPage(int page) => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 420),
        curve: transactionSheetCurve,
      );

  void _changeType(TransactionType value) {
    final matches = _categories.where((item) => item.transactionType == value);
    setState(() {
      _type = value;
      if (_category?.transactionType != value && matches.isNotEmpty) {
        _category = matches.first;
      }
    });
  }

  void _submit() {
    // Keep the stored amount when only another field was edited: converting
    // a rounded display value back to MGA can change an untouched amount.
    final amount =
        parseAmountInput(_amountController.text) == _initialDisplayAmount
            ? widget.entry.amount.round()
            : CurrencyAmountInput.toMga(
                _amountController.text, widget.currencyState);
    if (_titleController.text.trim().isEmpty ||
        amount <= 0 ||
        _category == null) {
      showInfoToast(context, 'Enter a title and a positive amount.');
      return;
    }
    final input = ManualEntryInput(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      amount: amount,
      transactionType: _type.value,
      categoryId: _category!.id,
      occurredAt: widget.entry.occurredAt,
      sourceWalletId: widget.entry.sourceWalletId,
      useAllWallets: widget.entry.usedMultipleWallets,
    );
    Navigator.pop(context, ManualEntrySheetResult.save(input));
  }
}
