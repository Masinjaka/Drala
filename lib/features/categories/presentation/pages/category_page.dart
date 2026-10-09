import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/core/ui/detail_page_shell.dart';
import 'package:budgets/features/categories/presentation/widgets/category_tab_content.dart';
import 'package:budgets/features/categories/presentation/widgets/category_editor_sheet.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_type_selector.dart';
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
        title: context.l10n.categories,
        onAdd: () => CategoryEditorSheet.show(context,
            type: _tabs.index == 0
                ? TransactionType.expense
                : TransactionType.income),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 41),
              child: TransactionTypeSelector(
                value: _tabs.index == 0
                    ? TransactionType.expense
                    : TransactionType.income,
                incomeLabel: context.l10n.income,
                expenseLabel: context.l10n.expense,
                onChanged: (type) =>
                    _tabs.animateTo(type == TransactionType.expense ? 0 : 1),
              )),
          const SizedBox(height: 24),
          Expanded(
              child: TabBarView(controller: _tabs, children: const [
            CategoryTabContent(transactionType: TransactionType.expense),
            CategoryTabContent(transactionType: TransactionType.income),
          ])),
        ]));
  }
}
