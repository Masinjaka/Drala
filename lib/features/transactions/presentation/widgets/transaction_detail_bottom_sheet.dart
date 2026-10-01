import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/features/transactions/domain/providers/transaction_provider.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_detail_edit_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionDetailBottomSheet extends ConsumerStatefulWidget {
  const TransactionDetailBottomSheet({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  ConsumerState<TransactionDetailBottomSheet> createState() =>
      _TransactionDetailBottomSheetState();
}

class _TransactionDetailBottomSheetState
    extends ConsumerState<TransactionDetailBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _amountController = TextEditingController();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TransactionType _type;
  Category? _category;
  bool _amountInitialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.transaction.transactionType ?? TransactionType.expense;
    _category = widget.transaction.category;
    _titleController = TextEditingController(
      text: widget.transaction.title ?? widget.transaction.category?.name ?? '',
    );
    _descriptionController =
        TextEditingController(text: widget.transaction.description ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_amountInitialized) return;
    final currency = ref.read(currencyControllerProvider).value;
    final rate = currency?.rateFor(currency.code) ?? 1;
    final value = convertFromMga(widget.transaction.amount, rate);
    final locale = Localizations.localeOf(context).toLanguageTag();
    _amountController.text = NumberFormat('#,##0.##', locale).format(value);
    _amountInitialized = true;
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
    final currency = ref.watch(currencyControllerProvider).value;
    final allCategories =
        ref.watch(categoriesProvider).value ?? const <Category>[];
    final categories = allCategories
        .where((item) =>
            item.transactionType == null || item.transactionType == _type)
        .toList(growable: false);
    final available = _includeSelected(categories);
    return TransactionSheetSurface(
      pageController: _pageController,
      pages: [
        TransactionDetailEditPage(
          formKey: _formKey,
          amountController: _amountController,
          titleController: _titleController,
          descriptionController: _descriptionController,
          currencyCode: currency?.code ?? 'MGA',
          type: _type,
          category: _category,
          saving: _saving,
          onTypeChanged: _changeType,
          onCategoryTap: () => _goToPage(1),
          onCategoryClear: () => setState(() => _category = null),
          onClose: () => Navigator.pop(context),
          onDelete: _delete,
          onSave: _save,
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

  List<Category> _includeSelected(List<Category> categories) {
    final selected = _category;
    if (selected == null || categories.any((item) => item.id == selected.id)) {
      return categories;
    }
    return [selected, ...categories];
  }

  void _goToPage(int page) => _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 420),
        curve: transactionSheetCurve,
      );

  void _changeType(TransactionType value) {
    setState(() {
      _type = value;
      if (_category?.transactionType != null &&
          _category?.transactionType != value) {
        _category = null;
      }
    });
  }

  double _displayAmount() {
    var value =
        _amountController.text.replaceAll(RegExp(r'[\s\u00A0\u202F]'), '');
    if (value.contains(',') && !value.contains('.')) {
      value = value.replaceAll(',', '.');
    }
    return double.tryParse(value.replaceAll(',', '')) ?? 0;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _category == null) return;
    setState(() => _saving = true);
    try {
      final currency = await ref.read(currencyControllerProvider.future);
      final amount =
          convertToMga(_displayAmount(), currency.rateFor(currency.code));
      await ref.read(transactionsProvider.notifier).editTransaction(
            widget.transaction.id!,
            amount.round().toString(),
            _descriptionController.text.trim(),
            _category!.name,
            null,
            _type,
            widget.transaction.date,
            originalTransaction: widget.transaction,
            title: _titleController.text.trim(),
          );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final id = widget.transaction.id;
    if (id == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(transactionsProvider.notifier).deleteTransaction(
            id,
            _type,
            transaction: widget.transaction,
          );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
