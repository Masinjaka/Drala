import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_label.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:flutter/material.dart';

class TransactionCategoryField extends StatelessWidget {
  const TransactionCategoryField({
    super.key,
    this.requiredMessage,
    required this.label,
    required this.category,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final String? requiredMessage;
  final Category? category;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (FinanceSheetScope.of(context))
      return ValidatedSelection(
          value: category?.id,
          validator: () => FieldValidators.required(context, category?.id,
              message: requiredMessage),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AppFinanceSurfaceTheme.label(context)),
            const SizedBox(height: 10),
            Material(
                key: const Key('transaction-category-field'),
                color: AppFinanceSurfaceTheme.field(context),
                shape: RoundedRectangleBorder(
                    borderRadius: AppFinanceSurfaceTheme.fieldRadius,
                    side: BorderSide(
                        color: AppFinanceSurfaceTheme.border(context))),
                child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onTap();
                    },
                    borderRadius: AppFinanceSurfaceTheme.fieldRadius,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 38),
                            child: Row(children: [
                              Expanded(
                                  child: Text(category?.name ?? label,
                                      style: AppFinanceSurfaceTheme.label(
                                          context))),
                              if (category != null)
                                CategoryIcon(
                                    iconKey: category?.iconKey,
                                    emoji: category?.emoji,
                                    colorHex: category?.color,
                                    size: 20),
                            ]))))),
          ]));
    return ValidatedSelection(
        value: category?.id,
        validator: () => FieldValidators.required(context, category?.id,
            message: requiredMessage),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 7),
          Material(
            key: const ValueKey('transaction-category-field'),
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                onTap();
              },
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 40,
                child: Row(children: [
                  const SizedBox(width: 10),
                  if (category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CategoryIconLabel(
                          name: category?.name ?? '',
                          iconKey: category?.iconKey,
                          emoji: category?.emoji,
                          colorHex: category?.color,
                          backgroundColor: colors.surfaceContainerLowest,
                          style: Theme.of(context).textTheme.labelSmall),
                    ),
                  const Spacer(),
                  const SizedBox(width: 3),
                ]),
              ),
            ),
          ),
        ]));
  }
}
