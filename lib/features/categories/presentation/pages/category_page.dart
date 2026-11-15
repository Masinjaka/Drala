import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_bottom_action.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/detail_page_shell.dart';
import 'package:budgets/features/categories/presentation/widgets/category_tab_content.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/categories/presentation/widgets/category_type_carousel.dart';
import 'package:budgets/core/ui/app_category_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this)
    ..addListener(_onTabChanged);

  void _onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabChanged);
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailPageShell(
        showGrid: false,
        maxWidth: 900,
        backgroundColor: AppCategoryTheme.background(context),
        title: context.l10n.categories,
        bottomNavigationBar: AppBottomAction(
            buttonKey: const Key('category-create'),
            label: context.l10n.create,
            onPressed: () => CategoryEditorSheet.show(context,
                type: _tabs.index == 0
                    ? TransactionType.expense
                    : TransactionType.income)),
        headerBottom: Column(children: [
          Padding(
              padding: AppPageSpacing.insets(context),
              child: CategoryTypeCarousel(controller: _tabs)),
          const SizedBox(height: 24),
        ]),
        child: TabBarView(controller: _tabs, children: const [
          CategoryTabContent(transactionType: TransactionType.expense),
          CategoryTabContent(transactionType: TransactionType.income),
        ]));
  }
}
