import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_category_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/utils/error_messages.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'category_empty_state.dart';
import 'category_grid_card.dart';

class CategoryTabContent extends ConsumerWidget {
  const CategoryTabContent({super.key, required this.transactionType});
  final TransactionType transactionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    return Padding(
      padding: AppPageSpacing.insets(context, bottom: 24),
      child: switch (categories) {
        AsyncData(:final value) => _grid(
            context,
            value
                .where((item) => item.transactionType == transactionType)
                .toList()),
        AsyncError(:final error) => Center(
            child: Text(friendlyErrorMessage(error),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center)),
        _ => _grid(context, null),
      },
    );
  }

  Widget _grid(BuildContext context, List<Category>? categories) {
    if (categories != null && categories.isEmpty) {
      return CategoryEmptyState(type: transactionType);
    }
    return LayoutBuilder(builder: (context, constraints) {
      final columns = (constraints.maxWidth / 180).floor().clamp(2, 4);
      final scaled = MediaQuery.textScalerOf(context).scale(12);
      final height = 144 + (scaled - 12).clamp(0.0, double.infinity) * 4;
      return GridView.builder(
        key: PageStorageKey(transactionType),
        padding: EdgeInsets.zero,
        itemCount: categories?.length ?? 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: height,
        ),
        itemBuilder: (context, index) => categories == null
            ? Container(
                decoration: BoxDecoration(
                    color: AppCategoryTheme.surface(context),
                    borderRadius: AppCategoryTheme.cardRadius),
                child: const Center(child: ValueSkeleton()))
            : CategoryGridCard(
                key: ValueKey(categories[index].id),
                category: categories[index],
                type: transactionType),
      );
    });
  }
}
