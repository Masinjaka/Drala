import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/category_appearance_field.dart';
import 'package:budgets/features/categories/presentation/widgets/category_emoji_picker.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_edit_scroll_view.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_field.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryEditorSheet extends ConsumerStatefulWidget {
  const CategoryEditorSheet({required this.type, this.category, super.key});

  final TransactionType type;
  final Category? category;

  static Future<void> show(BuildContext context,
          {required TransactionType type, Category? category}) =>
      showTransactionFormSheet<void>(context,
          builder: (_) => CategoryEditorSheet(type: type, category: category));

  @override
  ConsumerState<CategoryEditorSheet> createState() =>
      _CategoryEditorSheetState();
}

class _CategoryEditorSheetState extends ConsumerState<CategoryEditorSheet> {
  final _pages = PageController();
  late final _name = TextEditingController(text: widget.category?.name);
  String? _emoji;
  late Color _color;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _emoji = widget.category?.emoji;
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

  Future<void> _pickEmoji() async {
    final selected = await CategoryEmojiPicker.show(context);
    if (mounted && selected != null) setState(() => _emoji = selected);
  }

  Future<void> _pickColor() async {
    var selected = _color;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            color: selected,
            onColorChanged: (value) => selected = value,
            wheelDiameter: 200,
            pickersEnabled: const {ColorPickerType.wheel: true},
          ),
        ),
        actions: [
          CustomButton.text(
            text: context.l10n.save,
            width: 80,
            height: 40,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
    if (mounted && confirmed == true) setState(() => _color = selected);
  }

  Future<void> _save() async {
    if (_saving) return;
    final name = _name.text.trim();
    if (name.isEmpty || _emoji == null || _emoji!.isEmpty) {
      showInfoToast(context, context.l10n.name);
      return;
    }
    setState(() => _saving = true);
    try {
      final value = Category(
        id: widget.category?.id,
        name: name,
        emoji: _emoji,
        color: _color.toARGB32().toRadixString(16).padLeft(8, '0'),
        transactionType: widget.category?.transactionType ?? widget.type,
      );
      final categories = ref.read(categoriesProvider.notifier);
      if (widget.category == null) {
        await categories.addSomeCategory(value);
      } else {
        await categories.editSomeCategory(value);
      }
      if (mounted) Navigator.of(context).pop();
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
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => TransactionSheetSurface(
        pageController: _pages,
        pages: [
          TransactionEditScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransactionFormHeader(
                    title: context.l10n.categories,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 37),
                  TransactionSheetField(
                    label: context.l10n.name,
                    controller: _name,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  CategoryAppearanceField(
                    emoji: _emoji,
                    color: _color,
                    onEmojiTap: _pickEmoji,
                    onColorTap: _pickColor,
                  ),
                  const Spacer(),
                  TransactionFormActions(
                    saving: _saving,
                    onSave: _save,
                    onDelete: widget.category == null ? null : _delete,
                  ),
                ],
              ),
            ),
          )
        ],
      );
}
