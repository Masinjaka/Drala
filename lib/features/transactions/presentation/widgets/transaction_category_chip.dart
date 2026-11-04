import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_label.dart';
import 'package:budgets/core/ui/app_button_theme.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:flutter/material.dart';

class TransactionCategoryChip extends StatefulWidget {
  const TransactionCategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<TransactionCategoryChip> createState() =>
      _TransactionCategoryChipState();
}

class _TransactionCategoryChipState extends State<TransactionCategoryChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 110),
    );
    _scale = Tween(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = widget.selected
        ? colors.inverseSurface
        : FinanceSheetScope.of(context)
            ? AppFinanceSurfaceTheme.background(context)
            : colors.surfaceContainerLowest;
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        key: ValueKey('category-${widget.category.id ?? widget.category.name}'),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: _controller.reverse,
        onTap: widget.onTap,
        child: Material(
          color: background,
          shape: AppButtonTheme.shape.copyWith(
            side: FinanceSheetScope.of(context)
                ? BorderSide.none
                : BorderSide(
                    color: widget.selected
                        ? colors.inverseSurface
                        : colors.outlineVariant,
                  ),
          ),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: FinanceSheetScope.of(context)
                      ? AppFinanceSurfaceTheme.selectionHeight
                      : 0),
              child: Padding(
                padding: FinanceSheetScope.of(context)
                    ? AppFinanceSurfaceTheme.selectionPadding
                    : const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                child: CategoryIconLabel(
                  name: widget.category.name ?? '',
                  iconKey: widget.category.iconKey,
                  emoji: widget.category.emoji,
                  colorHex: widget.category.color,
                  backgroundColor: background,
                  color: widget.selected
                      ? colors.onInverseSurface
                      : colors.onSurface,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: widget.selected
                            ? colors.onInverseSurface
                            : colors.onSurface,
                      ),
                ),
              )),
        ),
      ),
    );
  }
}
