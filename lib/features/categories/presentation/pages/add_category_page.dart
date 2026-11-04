import 'package:budgets/core/ui/app_delete_button.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_close_button.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/ui/glass_flexible_space.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/constants.dart';
import 'package:budgets/features/planning/data/datasources/goal_datasource.dart'
    as goal_datasource;
import 'package:go_router/go_router.dart';
import 'package:budgets/features/categories/presentation/modules/categori_module.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart'
    hide CategoryIcon;
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart'
    as cat;

part 'add_category_emoji_picker.dart';
part 'add_category_layout.dart';
part 'add_category_savings_info.dart';
part 'add_category_name_and_emoji.dart';
part 'add_category_color_and_delete.dart';

class AddCategoryPage extends ConsumerStatefulWidget {
  final cat.Category? category;
  final String transactionType;

  const AddCategoryPage({
    super.key,
    this.category,
    this.transactionType = 'expense',
  });

  @override
  ConsumerState<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends ConsumerState<AddCategoryPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _emoticonController = TextEditingController();
  String? _selectedEmoji;
  Color? _selectedColor;
  final CategoryModule _categoryModule = CategoryModule();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isDeleting = false;
  bool _isSavingsCategoryWithGoals = false;

  // Get transaction type from widget
  TransactionType get transactionType =>
      TransactionType.fromValue(widget.transactionType) ??
      TransactionType.expense;

  /// Check if this is the savings category and user has goals
  bool get _isSavingsCategory =>
      widget.category != null &&
      widget.category!.name == SystemCategories.savingsCategoryName;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _isEditing = true;
      _categoryNameController.text = widget.category!.name!;
      _selectedEmoji = widget.category!.emoji!;
      _selectedColor = Color(int.parse(widget.category!.color!, radix: 16));

      // Check if this is savings category with goals
      if (_isSavingsCategory) {
        _checkForGoals();
      }
    }
  }

  Future<void> _checkForGoals() async {
    final hasGoals = await goal_datasource.hasAnyGoals();
    if (mounted) {
      setState(() {
        _isSavingsCategoryWithGoals = hasGoals;
      });
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _emoticonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);

  void _update(VoidCallback action) => setState(action);
}
