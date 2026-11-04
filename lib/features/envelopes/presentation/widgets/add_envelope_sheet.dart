import 'package:budgets/features/envelopes/domain/models/envelope_save_cancelled.dart';
import 'package:budgets/core/forms/submit_validated_form.dart';
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
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';

part 'add_envelope_sheet_submission.dart';

class AddEnvelopeSheet extends StatefulWidget {
  const AddEnvelopeSheet({
    required this.categories,
    required this.month,
    required this.onSave,
    this.currencyState,
    this.fundingField,
    this.envelope,
    this.onDelete,
    super.key,
  });

  final List<EnvelopeCategory> categories;
  final DateTime month;
  final Future<void> Function(String, String, int, bool) onSave;
  final CurrencyState? currencyState;
  final Widget? fundingField;
  final Envelope? envelope;
  final Future<void> Function()? onDelete;

  static Future<void> show(
    BuildContext context, {
    required List<EnvelopeCategory> categories,
    required DateTime month,
    required Future<void> Function(String, String, int, bool) onSave,
    CurrencyState? currencyState,
    Widget? fundingField,
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
          fundingField: fundingField,
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
  final _formKey = GlobalKey<FormState>();
  Category? _category;
  final List<Category> _createdCategories = [];
  bool _saving = false;
  bool _repeatsMonthly = false;

  void _setSaving(bool value) => setState(() => _saving = value);

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
        iconKey: envelope.iconKey,
        color: envelope.color);
    _repeatsMonthly = envelope.repeatsMonthly;
  }

  Future<void> _delete() async {
    if (_saving || widget.onDelete == null) return;
    final confirmed = await showDeleteConfirmationDialog(
        context: context,
        title: context.l10n.deleteEnvelope,
        message: context.l10n.deleteEnvelopeDescription);
    if (!mounted || !confirmed) return;
    setState(() => _saving = true);
    try {
      await widget.onDelete!();
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted && error is! EnvelopeSaveCancelled) {
        showErrorToast(context, error);
      }
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

  @override
  Widget build(BuildContext context) => SubmitValidatedForm(
      formKey: _formKey,
      child: TransactionSheetSurface(
        referenceStyle: true,
        pageController: _pages,
        pages: [
          EnvelopeFormPage(
            editing: widget.envelope != null,
            fundingField: widget.fundingField,
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
            categories: [
              ..._createdCategories,
              ...widget.categories.map((value) => Category(
                    id: value.id,
                    name: value.name,
                    emoji: value.emoji,
                    iconKey: value.iconKey,
                    color: value.color,
                  ))
            ],
            onCreate: () async {
              final created = await CategoryEditorSheet.show(context,
                  type: TransactionType.expense);
              if (mounted && created != null) {
                setState(() {
                  _createdCategories.add(created);
                  _category = created;
                });
              }
            },
            selected: _category,
            onSelected: (value) => setState(() => _category = value),
            onBack: () => _goToPage(0),
          ),
        ],
      ));
}
