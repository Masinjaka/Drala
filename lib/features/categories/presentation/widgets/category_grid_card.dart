import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_category_theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/features/categories/data/datasource/category_api.dart'
    as category_api;
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/planning/data/datasources/goal_datasource.dart'
    as goal_datasource;
import 'package:flutter/material.dart';
import 'category_editor_sheet.dart';
import 'category_icon.dart';

class CategoryGridCard extends StatefulWidget {
  const CategoryGridCard(
      {required this.category, required this.type, super.key});
  final Category category;
  final TransactionType type;

  @override
  State<CategoryGridCard> createState() => _CategoryGridCardState();
}

class _CategoryGridCardState extends State<CategoryGridCard> {
  late Future<bool> _locked = _loadLock();

  Future<bool> _loadLock() => category_api.isSavingsCategory(widget.category)
      ? goal_datasource.hasAnyGoals()
      : Future.value(false);

  @override
  void didUpdateWidget(CategoryGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) _locked = _loadLock();
  }

  Future<void> _open() async {
    if (category_api.isSavingsCategory(widget.category) &&
        await goal_datasource.hasAnyGoals()) {
      if (mounted) {
        showInfoToast(context,
            'Cette catégorie est utilisée pour vos objectifs d\'épargne et ne peut pas être modifiée.');
      }
      return;
    }
    if (mounted) {
      await CategoryEditorSheet.show(context,
          type: widget.type, category: widget.category);
      if (mounted) {
        setState(() {
          _locked = _loadLock();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppCardSurface(
        color: AppCategoryTheme.surface(context),
        borderRadius: AppCategoryTheme.cardRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _open,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CategoryIcon(
                    iconKey: widget.category.iconKey,
                    emoji: widget.category.emoji,
                    colorHex: widget.category.color,
                  ),
                  const Spacer(),
                  FutureBuilder<bool>(
                    future: _locked,
                    builder: (context, snapshot) => Icon(
                      snapshot.data == true
                          ? Icons.lock_outline
                          : Icons.arrow_forward_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ]),
                const Spacer(),
                Text(widget.category.name ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppCategoryTheme.name(context)),
              ],
            ),
          ),
        ),
      );
}
