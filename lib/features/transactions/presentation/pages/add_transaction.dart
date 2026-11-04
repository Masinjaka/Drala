import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/core/constants.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/glass_flexible_space.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/models/subcategories.dart';
import 'package:budgets/features/transactions/domain/model/transaction_model.dart';
import 'package:budgets/features/transactions/presentation/modules/transaction_module.dart';
import 'package:budgets/features/transactions/presentation/pages/add_transaction/multiple_amounts_section.dart';
import 'package:budgets/features/transactions/presentation/pages/add_transaction/transaction_creation_initializer.dart';
import 'package:budgets/features/transactions/presentation/widgets/add_transaction/detailed_transaction_switch.dart';
import 'package:budgets/features/transactions/presentation/widgets/add_transaction/subcategory_amount_row.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_date_picker_field.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/widgets/custom_dropdown.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'add_transaction_build_removed_item.dart';
part 'add_transaction_build.dart';
part 'add_transaction_build_body.dart';
part 'add_transaction_build_add_button.dart';

class TransactionCreationPage extends ConsumerStatefulWidget {
  final String transactionType;
  final TransactionModel? transaction;

  const TransactionCreationPage(
      {super.key, this.transactionType = 'expense', this.transaction});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionCreationPageState();
}

class _TransactionCreationPageState
    extends ConsumerState<TransactionCreationPage> {
  void _update(VoidCallback action) => setState(action);

  final _formKey = GlobalKey<FormState>();
  final _module = TransactionModule();
  final _listKey = GlobalKey<AnimatedListState>();
  final _designationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _montantController = TextEditingController();
  DateTime? _selectedDate;
  List<Category> _categories = [];
  Category? _selectedCategory;
  List<Subcategory> _subcategories = [];
  bool _isMultipleAmounts = false, _isLoading = false, _isInitializing = false;
  final List<Map<String, dynamic>> _subcategoryAmounts = [];

  TransactionType get transactionType =>
      TransactionType.fromValue(widget.transactionType) ??
      TransactionType.expense;
  bool get isEditMode => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    _isInitializing = isEditMode;
    if (isEditMode) {
      _descriptionController.text = widget.transaction!.description ?? '';
      _selectedDate = widget.transaction!.date;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await TransactionCreationInitializer.initialize(
        ref: ref,
        isEditMode: isEditMode,
        transaction: widget.transaction,
        transactionType: transactionType,
        module: _module,
      );
      if (!mounted) return;
      setState(() {
        _categories = data.categories;
        _selectedCategory = data.selectedCategory;
        _subcategories = data.subcategories;
        _isMultipleAmounts = data.isMultipleAmounts;
        if (data.subcategoryAmounts.isNotEmpty)
          _subcategoryAmounts.addAll(data.subcategoryAmounts);
        if (data.amountText != null) _montantController.text = data.amountText!;
        _isInitializing = false;
      });
    });
  }

  @override
  void dispose() {
    _designationController.dispose();
    _descriptionController.dispose();
    _montantController.dispose();
    for (var item in _subcategoryAmounts) {
      item['subcategoryController']?.dispose();
      item['amountController']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildFormContent(context);

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: const GlassFlexibleSpace(),
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      title: Text(
        isEditMode
            ? (transactionType == TransactionType.income
                ? 'Modifier le revenu'
                : 'Modifier la dépense')
            : (transactionType == TransactionType.income
                ? 'Nouveau revenu'
                : 'Nouvelle dépense'),
        style: AppTextStyle(AppTextRole.sheetTitle),
      ),
    );
  }
}
