import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/forms/field_validators.dart';
import 'package:budgets/core/forms/validated_input.dart';
import 'package:budgets/core/forms/validated_selection.dart';
import 'package:budgets/widgets/animated_amount_field.dart';
import 'package:flutter/material.dart';

class SubcategoryAmountCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final void Function(int) onRemove;
  final Future<void> Function(Map<String, dynamic>, int) onSubcategoryTap;

  const SubcategoryAmountCard({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onSubcategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final amountController = item['amountController'] as TextEditingController;
    final subcategoryName = item['subcategoryName'] as String? ?? '';
    return Container(
      margin: EdgeInsets.only(right: 12),
      height: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValidatedInput(
                      controller: amountController,
                      validator: (value) =>
                          FieldValidators.positiveAmount(context, value),
                      child: AnimatedSubcategoryAmountField(
                        controller: amountController,
                        hint: '0.00',
                        fontSize: AppTypography.display,
                        fillColor: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      )),
                  SizedBox(height: 8),
                  ValidatedSelection(
                      value: subcategoryName.isEmpty ? null : subcategoryName,
                      child: GestureDetector(
                        onTap: () => onSubcategoryTap(item, index),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceDim,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subcategoryName.isNotEmpty
                                ? subcategoryName
                                : 'Choisir une sous-catégorie',
                            style: AppTextStyle(AppTextRole.body,
                                color: subcategoryName.isNotEmpty
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                    : Theme.of(context).hintColor),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => onRemove(index),
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surfaceDim,
                ),
                child: const Center(child: Icon(Icons.remove)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
