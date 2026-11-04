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
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/categories/presentation/widgets/add_category_dialog.dart';
import 'package:budgets/features/planning/domain/models/budget_model.dart';
import 'package:budgets/features/planning/domain/providers/budget_provider.dart';
import 'package:budgets/widgets/animated_amount_field.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/widgets/skeleton/planning_skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog for adding or editing a budget.
part 'add_budget_bottom_sheet_save_budget.dart';
part 'add_budget_bottom_sheet_on_add_category_tap.dart';
part 'add_budget_bottom_sheet_build.dart';
part 'add_budget_bottom_sheet_build_category_section.dart';
part 'add_budget_bottom_sheet_build_category_pills.dart';
part 'add_budget_bottom_sheet_build_category_pill.dart';
part 'add_budget_bottom_sheet_build_add_category_pill.dart';
part 'add_budget_bottom_sheet_build_period_dropdown.dart';

class AddBudgetBottomSheet extends ConsumerStatefulWidget {
  final Budget? budget;

  const AddBudgetBottomSheet({super.key, this.budget});

  static Future<bool?> show(BuildContext context, {Budget? budget}) {
    return showAppSheet<bool>(
      context,
      barrierDismissible: true,
      builder: (_) => AddBudgetBottomSheet(budget: budget),
    );
  }

  @override
  ConsumerState<AddBudgetBottomSheet> createState() =>
      _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends ConsumerState<AddBudgetBottomSheet> {
  void _update(VoidCallback action) => setState(action);

  static const Map<String, String> _periodLabels = {
    'monthly': 'Mensuel',
    'weekly': 'Hebdomadaire',
    'bimonthly': 'Bimensuel',
    'biweekly': 'Toutes les 2 semaines',
    'yearly': 'Annuel',
  };

  final AmountTextEditingController _amountController =
      AmountTextEditingController();

  String? _selectedCategoryId;
  String _selectedPeriod = 'monthly';
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _selectedCategoryId = widget.budget!.category?.id;
      final initialPeriod = widget.budget!.period?.toLowerCase().trim();
      if (_periodLabels.containsKey(initialPeriod)) {
        _selectedPeriod = initialPeriod!;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.budget?.amount == null) return;
      final currencyState = await ref.read(currencyControllerProvider.future);
      final rate = currencyState.rateFor(currencyState.code);
      final cleanAmount =
          widget.budget!.amount!.replaceAll(RegExp(r'[^\d]'), '');
      final amountMga = double.tryParse(cleanAmount) ?? 0;
      final displayAmount = convertFromMga(amountMga, rate);
      _amountController.text = formatAmountValue(displayAmount);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildFormContent(context);
}
