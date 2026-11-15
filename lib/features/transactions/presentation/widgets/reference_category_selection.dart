import 'package:budgets/core/ui/app_close_button.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'transaction_category_chip.dart';
import 'transaction_category_create_chip.dart';

class ReferenceCategorySelection extends StatelessWidget {
  const ReferenceCategorySelection(
      {required this.controller,
      required this.categories,
      required this.selected,
      required this.onSearch,
      required this.onSelected,
      required this.onBack,
      this.onCreate,
      this.loading = false,
      super.key});
  final TextEditingController controller;
  final List<Category> categories;
  final Category? selected;
  final ValueChanged<String> onSearch;
  final ValueChanged<Category> onSelected;
  final VoidCallback onBack;
  final VoidCallback? onCreate;
  final bool loading;
  @override
  Widget build(BuildContext context) => Material(
      color: AppFinanceSurfaceTheme.background(context),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppCloseButton(
                    key: const Key('category-back'), onPressed: onBack)),
            const SizedBox(height: 24),
            TextField(
                key: const Key('category-search'),
                controller: controller,
                onChanged: onSearch,
                style: AppFinanceSurfaceTheme.label(context),
                decoration: AppFinanceSurfaceTheme.input(context,
                    hint: context.l10n.searchCategories,
                    prefix: const Icon(Icons.search, size: 20))),
            const SizedBox(height: 24),
            Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Wrap(spacing: 8, runSpacing: 10, children: [
                        for (final category in categories)
                          TransactionCategoryChip(
                              category: category,
                              selected: category.id != null
                                  ? category.id == selected?.id
                                  : category.name == selected?.name,
                              onTap: () => onSelected(category)),
                        if (onCreate != null)
                          TransactionCategoryCreateChip(onTap: onCreate!),
                      ]))),
          ])));
}
