import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_input.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/utils/animated_dialog.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/models/subcategories.dart';
import 'package:budgets/features/categories/presentation/widgets/add_category_dialog.dart';
import 'package:budgets/features/categories/presentation/widgets/subcategory_selection_dialog.dart';
import 'package:budgets/features/transactions/presentation/modules/transaction_module.dart';
import 'package:budgets/features/transactions/presentation/widgets/add_transaction/category_pills_section.dart';
import 'package:budgets/features/transactions/presentation/widgets/add_transaction/dialog_chrome.dart';
import 'package:budgets/features/transactions/presentation/widgets/add_transaction/subcategory_pager_section.dart';
import 'package:budgets/widgets/animated_amount_field.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'add_transaction_dialog_load_categories.dart';
part 'add_transaction_dialog_clear_subcategory_amounts.dart';
part 'add_transaction_dialog_add_card.dart';
part 'add_transaction_dialog_remove_card.dart';
part 'add_transaction_dialog_on_subcategory_tap.dart';
part 'add_transaction_dialog_on_category_tap.dart';
part 'add_transaction_dialog_submit.dart';
part 'add_transaction_dialog_build.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  final TransactionType transactionType;

  const AddTransactionDialog({super.key, required this.transactionType});

  static Future<bool?> show(BuildContext context,
      {required TransactionType transactionType}) {
    return showAnimatedDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          AddTransactionDialog(transactionType: transactionType),
    );
  }

  @override
  ConsumerState<AddTransactionDialog> createState() =>
      _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  void _update(VoidCallback action) => setState(action);

  final _formKey = GlobalKey<FormState>();
  final _module = TransactionModule();
  final _montantController = AmountTextEditingController();
  final _descriptionController = TextEditingController();
  final _pageController = PageController(viewportFraction: 0.80);
  List<Category> _categories = [];
  Category? _selectedCategory;
  List<Subcategory> _subcategories = [];
  final List<Map<String, dynamic>> _subcategoryAmounts = [];
  final Set<int> _removingIndices = {};
  int? _newlyAddedIndex;
  bool _isLoading = false, _isInitializing = true, _isPerSubcategory = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _montantController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    for (var item in _subcategoryAmounts) {
      item['subcategoryController']?.dispose();
      item['amountController']?.dispose();
    }
    super.dispose();
  }

  void _togglePerSubcategory(bool value) => setState(() {
        _isPerSubcategory = value;
        if (!value) _clearSubcategoryAmounts();
      });

  @override
  Widget build(BuildContext context) => _buildFormContent(context);
}

// Dialog widgets extracted to add_transaction/dialog_chrome.dart
