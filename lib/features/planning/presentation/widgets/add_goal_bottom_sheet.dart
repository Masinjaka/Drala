import 'package:budgets/core/ui/app_loader.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_input.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'dart:io';

import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/functions/pick_image_with_permissions.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/add_category_dialog.dart';
import 'package:budgets/features/planning/domain/models/goal_model.dart';
import 'package:budgets/features/planning/domain/providers/goal_provider.dart';
import 'package:budgets/widgets/animated_amount_field.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/widgets/custom_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dialog for adding or editing a goal.
part 'add_goal_bottom_sheet_go_to_next_step.dart';
part 'add_goal_bottom_sheet_select_date.dart';
part 'add_goal_bottom_sheet_pick_image.dart';
part 'add_goal_bottom_sheet_on_add_category_tap.dart';
part 'add_goal_bottom_sheet_save_goal.dart';
part 'add_goal_bottom_sheet_build.dart';
part 'add_goal_bottom_sheet_build_step_indicator.dart';
part 'add_goal_bottom_sheet_build_step_one.dart';
part 'add_goal_bottom_sheet_build_step_two.dart';
part 'add_goal_bottom_sheet_build_category_section.dart';
part 'add_goal_bottom_sheet_build_category_pills.dart';
part 'add_goal_bottom_sheet_build_category_pill.dart';
part 'add_goal_bottom_sheet_build_add_category_pill.dart';
part 'add_goal_bottom_sheet_build_name_field.dart';
part 'add_goal_bottom_sheet_build_date_picker.dart';
part 'add_goal_bottom_sheet_build_image_picker.dart';

class AddGoalBottomSheet extends ConsumerStatefulWidget {
  final Goal? goal;

  const AddGoalBottomSheet({super.key, this.goal});

  static Future<bool?> show(BuildContext context, {Goal? goal}) {
    return showAppSheet<bool>(
      context,
      barrierDismissible: true,
      builder: (_) => AddGoalBottomSheet(goal: goal),
    );
  }

  @override
  ConsumerState<AddGoalBottomSheet> createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends ConsumerState<AddGoalBottomSheet> {
  void _update(VoidCallback action) => setState(action);

  final AmountTextEditingController _amountController =
      AmountTextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final PageController _pageController = PageController();

  DateTime? _targetDate;
  String? _imagePath;
  String? _selectedCategoryId;
  int _currentStep = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.goal != null;

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _nameController.text = widget.goal!.name ?? '';
      _targetDate = widget.goal!.dateAim;
      _imagePath = widget.goal!.imagePath;
      _selectedCategoryId = widget.goal!.category?.id;
    }
    if (_targetDate != null) {
      _dateController.text =
          DateFormat('dd/MM/yyyy', 'fr_FR').format(_targetDate!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.goal?.goalAmount == null) return;
      final currencyState = await ref.read(currencyControllerProvider.future);
      final rate = currencyState.rateFor(currencyState.code);
      final amountMga = parseAmountInput(widget.goal!.goalAmount!);
      final displayAmount = convertFromMga(amountMga, rate);
      _amountController.text = formatAmountValue(displayAmount);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildFormContent(context);
}
