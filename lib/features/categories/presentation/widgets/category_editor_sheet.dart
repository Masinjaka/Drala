import 'package:budgets/core/forms/submit_validated_form.dart';
import 'package:budgets/core/ui/category_icons.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_appearance_field.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_picker.dart';
import 'package:budgets/features/categories/presentation/widgets/category_delete_error_toast.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_reference_layout.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'category_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryEditorSheet extends ConsumerStatefulWidget {
  const CategoryEditorSheet({required this.type, this.category, super.key});

  final TransactionType type;
  final Category? category;

  static Future<Category?> show(BuildContext context,
          {required TransactionType type, Category? category}) =>
      showTransactionFormSheet<Category>(context,
          builder: (_) => CategoryEditorSheet(type: type, category: category));

  @override
  ConsumerState<CategoryEditorSheet> createState() =>
      _CategoryEditorSheetState();
}

class _CategoryEditorSheetState extends ConsumerState<CategoryEditorSheet> {
  final _pages = PageController();
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.category?.name);
  late String _iconKey;
  late Color _color;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _iconKey = CategoryIcons.resolve(
        iconKey: widget.category?.iconKey, emoji: widget.category?.emoji);
    _color = widget.category?.color == null
        ? AppTheme.primaryGreen
        : Color(int.parse(widget.category!.color!, radix: 16));
  }

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final selected = await CategoryIconPicker.show(context,
        selected: _iconKey, colorHex: _color.toARGB32().toRadixString(16));
    if (mounted && selected != null) setState(() => _iconKey = selected);
  }

  Future<void> _pickColor() async {
    final selected = await CategoryColorPicker.show(context, _color);
    if (mounted && selected != null) setState(() => _color = selected);
  }

  Future<void> _save() async {
    if (_saving) return;
    final name = _name.text.trim();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final value = Category(
        id: widget.category?.id,
        name: name,
        emoji: '',
        iconKey: _iconKey,
        color: _color.toARGB32().toRadixString(16).padLeft(8, '0'),
        transactionType: widget.category?.transactionType ?? widget.type,
      );
      final categories = ref.read(categoriesProvider.notifier);
      Category saved = value;
      if (widget.category == null) {
        final id = await categories.addSomeCategory(value);
        saved = value.copyWith(id: id);
      } else {
        await categories.editSomeCategory(value);
      }
      if (mounted) Navigator.of(context).pop(saved);
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final category = widget.category;
    if (_saving || category == null) return;
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: context.l10n.deleteCategoryQuestion,
      message: context.l10n.deleteCategoryDescription,
    );
    if (!confirmed || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(categoriesProvider.notifier).deleteSomeCategory(category);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) showCategoryDeleteErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => SubmitValidatedForm(
      formKey: _formKey,
      child: TransactionSheetSurface(
          referenceStyle: true,
          pageController: _pages,
          pages: [
            TransactionReferenceLayout(
                actions: TransactionFormActions(
                    saving: _saving,
                    onSave: _save,
                    onCancel: widget.category == null
                        ? null
                        : () => Navigator.pop(context)),
                children: [
                  TransactionFormHeader(
                      title: context.l10n.categories,
                      onClose: () => Navigator.pop(context),
                      showDelete: widget.category != null,
                      onDelete:
                          widget.category == null || _saving ? null : _delete),
                  const SizedBox(height: 40),
                  TransactionSheetField(
                      label: context.l10n.name,
                      controller: _name,
                      validator: (value) => FieldValidators.required(
                          context, value,
                          message: context.l10n.categoryNameRequired),
                      textInputAction: TextInputAction.done),
                  const SizedBox(height: 24),
                  CategoryAppearanceField(
                      iconKey: _iconKey,
                      color: _color,
                      onIconTap: _pickIcon,
                      onColorTap: _pickColor),
                ]),
          ]));
}
