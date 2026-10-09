import 'package:budgets/core/currency/currency_amount_input.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_form_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_page.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_motion.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:flutter/material.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';

class AddEnvelopeSheet extends StatefulWidget {
  const AddEnvelopeSheet({
    required this.categories,
    required this.month,
    required this.onSave,
    this.currencyState,
    this.envelope,
    this.onDelete,
    super.key,
  });

  final List<EnvelopeCategory> categories;
  final DateTime month;
  final Future<void> Function(String, String, int, bool) onSave;
  final CurrencyState? currencyState;
  final Envelope? envelope;
  final Future<void> Function()? onDelete;

  static Future<void> show(
    BuildContext context, {
    required List<EnvelopeCategory> categories,
    required DateTime month,
    required Future<void> Function(String, String, int, bool) onSave,
    CurrencyState? currencyState,
    Envelope? envelope,
    Future<void> Function()? onDelete,
  }) =>
      showTransactionFormSheet<void>(
        context,
        builder: (_) => AddEnvelopeSheet(
          categories: categories,
          month: month,
          onSave: onSave,
          currencyState: currencyState,
          envelope: envelope,
          onDelete: onDelete,
        ),
      );

  @override
  State<AddEnvelopeSheet> createState() => _AddEnvelopeSheetState();
}

class _AddEnvelopeSheetState extends State<AddEnvelopeSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _pages = PageController();
  Category? _category;
  bool _saving = false;
  bool _repeatsMonthly = false;

  @override
  void initState() {
    super.initState();
    final envelope = widget.envelope;
    if (envelope == null) return;
    _nameController.text = envelope.name;
    _amountController.text = CurrencyAmountInput.fromStored(
        envelope.amount, envelope.currencyCode, widget.currencyState);
    _category = Category(
        id: envelope.categoryId,
        name: envelope.categoryName,
        emoji: envelope.emoji,
        color: envelope.color);
    _repeatsMonthly = envelope.repeatsMonthly;
  }

  Future<void> _delete() async {
    if (_saving || widget.onDelete == null) return;
    setState(() => _saving = true);
    try {
      await widget.onDelete!();
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _pages.dispose();
    super.dispose();
  }

  void _goToPage(int page) => _pages.animateToPage(page,
      duration: const Duration(milliseconds: 420),
      curve: transactionSheetCurve);

  Future<void> _save() async {
    if (_saving) return;
    final existing = widget.envelope;
    final unchangedAmount = existing != null &&
        _amountController.text ==
            CurrencyAmountInput.fromStored(
                existing.amount, existing.currencyCode, widget.currencyState);
    final amount = unchangedAmount
        ? existing.amount
        : CurrencyAmountInput.toMga(
            _amountController.text,
            widget.currencyState,
          );
    final name = _nameController.text.trim();
    if (name.isEmpty || amount <= 0 || _category == null) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(name, _category!.id!, amount, _repeatsMonthly);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => TransactionSheetSurface(
        pageController: _pages,
        pages: [
          EnvelopeFormPage(
            editing: widget.envelope != null,
            onDelete: widget.onDelete == null ? null : _delete,
            nameController: _nameController,
            amountController: _amountController,
            currencyCode: widget.currencyState?.code ?? 'MGA',
            category: _category,
            saving: _saving,
            onCategoryTap: () => _goToPage(1),
            onCategoryClear: () => setState(() => _category = null),
            onSave: _save,
            repeatsMonthly: _repeatsMonthly,
            onRepeatsMonthlyChanged: (value) =>
                setState(() => _repeatsMonthly = value),
          ),
          TransactionCategoryPage(
            categories: widget.categories
                .map((value) => Category(
                      id: value.id,
                      name: value.name,
                      emoji: value.emoji,
                      color: value.color,
                    ))
                .toList(growable: false),
            selected: _category,
            onSelected: (value) => setState(() => _category = value),
            onBack: () => _goToPage(0),
          ),
        ],
      );
}
