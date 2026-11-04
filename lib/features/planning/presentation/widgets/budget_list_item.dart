import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'dart:async';

import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/planning/domain/models/budget_model.dart';
import 'package:budgets/features/planning/domain/providers/budget_provider.dart';
import 'package:budgets/features/planning/presentation/widgets/add_budget_bottom_sheet.dart';
import 'package:budgets/features/planning/presentation/widgets/planning_common_widgets.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vibration/vibration.dart';

part 'budget_list_item_layout.dart';

class BudgetListItem extends ConsumerStatefulWidget {
  final Budget budget;
  final int index;

  const BudgetListItem({
    super.key,
    required this.budget,
    required this.index,
  });

  @override
  ConsumerState<BudgetListItem> createState() => _BudgetListItemState();
}

class _BudgetListItemState extends ConsumerState<BudgetListItem>
    with SingleTickerProviderStateMixin {
  static const double _deletePaneExtentRatio = 0.20;
  static const _dismissDuration = Duration(milliseconds: 220);

  bool _hasTriggeredHalfSwipeHaptic = false;
  bool _canVibrate = true;
  double _swipeProgress = 0;
  bool _isDismissing = false;
  late final SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this)
      ..animation.addListener(_handleSlideAnimation);
    _initializeVibrationSupport();
  }

  @override
  void dispose() {
    _slidableController.animation.removeListener(_handleSlideAnimation);
    _slidableController.dispose();
    super.dispose();
  }

  String _periodLabel(String? period) {
    switch (period) {
      case 'weekly':
        return 'Hebdomadaire';
      case 'biweekly':
        return 'Toutes les 2 semaines';
      case 'bimonthly':
        return 'Bimensuel';
      case 'yearly':
        return 'Annuel';
      case 'monthly':
      default:
        return 'Mensuel';
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) {
    return showDeleteConfirmationDialog(
      context: context,
      title: context.l10n.deleteBudgetQuestion,
      message: context.l10n.deleteBudgetDescription,
    );
  }

  Future<void> _initializeVibrationSupport() async {
    try {
      final canVibrate = await Vibration.hasVibrator();
      _canVibrate = canVibrate == true;
    } catch (_) {
      _canVibrate = false;
    }
  }

  Future<void> _triggerHalfSwipeVibration() async {
    if (!_canVibrate) {
      return;
    }
    try {
      await Vibration.vibrate(duration: 30);
    } catch (_) {
      // Keep swipe/delete flow resilient if vibration fails.
    }
  }

  void _handleSlideAnimation() {
    final ratio = _slidableController.ratio.abs();
    final progress = (ratio / _deletePaneExtentRatio).clamp(0.0, 1.0);

    if ((progress - _swipeProgress).abs() > 0.005 && mounted) {
      setState(() {
        _swipeProgress = progress;
      });
    }

    if (!_hasTriggeredHalfSwipeHaptic && progress >= 0.5) {
      unawaited(_triggerHalfSwipeVibration());
      _hasTriggeredHalfSwipeHaptic = true;
      return;
    }

    if (_hasTriggeredHalfSwipeHaptic && progress < 0.2) {
      _hasTriggeredHalfSwipeHaptic = false;
    }
  }

  Future<void> _resetSwipeFeedbackState() async {
    if (_hasTriggeredHalfSwipeHaptic || _swipeProgress > 0) {
      if (mounted) {
        setState(() {
          _hasTriggeredHalfSwipeHaptic = false;
          _swipeProgress = 0;
        });
      } else {
        _hasTriggeredHalfSwipeHaptic = false;
        _swipeProgress = 0;
      }
    }

    if (_slidableController.ratio != 0) {
      await _slidableController.close(duration: 120.ms);
    }
  }

  Future<void> _handleDeleteAction() async {
    if (_isDismissing) {
      return;
    }
    final budget = widget.budget;
    final shouldDelete = await _showDeleteDialog(context);
    if (!shouldDelete || budget.id == null) {
      await _resetSwipeFeedbackState();
      return;
    }

    await _resetSwipeFeedbackState();
    if (!mounted) {
      return;
    }

    setState(() {
      _isDismissing = true;
    });

    await Future.delayed(_dismissDuration);

    try {
      await ref.read(budgetsProvider.notifier).deleteSomeBudget(budget.id!);
    } catch (e) {
      debugPrint('Error deleting budget: $e');
      if (mounted) {
        setState(() {
          _isDismissing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => _buildContent(context);

  void _showEditDialog(BuildContext context) {
    AddBudgetBottomSheet.show(context, budget: widget.budget);
  }
}
