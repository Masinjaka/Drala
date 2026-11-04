import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'category_editor_sheet.dart';

class CategoryEmptyState extends StatelessWidget {
  const CategoryEmptyState({required this.type, super.key});
  final TransactionType type;
  @override
  Widget build(BuildContext context) => EmptyStatePhrase(
        title: context.l10n.emptyCategories,
        brief: true,
        illustrationAsset: 'assets/illustrations/empty_states/categories.png',
        action: EmptyStateAction(
            label: context.l10n.createCategory,
            onPressed: () => CategoryEditorSheet.show(context, type: type)),
      );
}
