import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_label.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_input.dart';
import 'dart:async';

import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/core/constants.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/utils/animated_dialog.dart';
import 'package:budgets/features/categories/data/datasource/category_api.dart'
    as category_api;
import 'package:budgets/features/planning/domain/models/goal_model.dart';
import 'package:budgets/features/planning/domain/providers/goal_provider.dart';
import 'package:budgets/features/planning/presentation/widgets/add_goal_bottom_sheet.dart';
import 'package:budgets/features/planning/presentation/widgets/planning_common_widgets.dart';
import 'package:budgets/features/stats/domain/providers/stats_provider.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/features/transactions/domain/providers/transaction_provider.dart';
import 'package:budgets/widgets/animated_amount_field.dart';
import 'package:budgets/widgets/custom_button.dart';
import 'package:budgets/widgets/delete_confirmation_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibration/vibration.dart';

part 'goal_list_item_format_date.dart';
part 'goal_list_item_show_delete_dialog.dart';
part 'goal_list_item_initialize_vibration_support.dart';
part 'goal_list_item_trigger_half_swipe_vibration.dart';
part 'goal_list_item_handle_slide_animation.dart';
part 'goal_list_item_reset_swipe_feedback_state.dart';
part 'goal_list_item_handle_delete_action.dart';
part 'goal_list_item_build.dart';
part 'goal_list_item_show_edit_dialog.dart';
part 'goal_list_item_show_add_amount_form.dart';
part 'goal_list_item_top_up_fields.dart';
part 'goal_list_item_build_header.dart';
part 'goal_list_item_build_amount_row.dart';

class GoalListItem extends ConsumerStatefulWidget {
  final Goal goal;
  final int index;

  const GoalListItem({
    super.key,
    required this.goal,
    required this.index,
  });

  @override
  ConsumerState<GoalListItem> createState() => _GoalListItemState();
}

class _GoalListItemState extends ConsumerState<GoalListItem>
    with SingleTickerProviderStateMixin {
  void _update(VoidCallback action) => setState(action);

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

  @override
  Widget build(BuildContext context) => _buildFormContent(context);
}
