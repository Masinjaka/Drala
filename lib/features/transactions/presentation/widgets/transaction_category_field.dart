import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:flutter/material.dart';

class TransactionCategoryField extends StatelessWidget {
  const TransactionCategoryField({
    super.key,
    required this.label,
    required this.category,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final Category? category;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      const SizedBox(height: 7),
      Material(
        key: const ValueKey('transaction-category-field'),
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 40,
            child: Row(children: [
              const SizedBox(width: 10),
              if (category != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${category?.emoji ?? '❓'} ${category?.name ?? ''}',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w400),
                  ),
                ),
              const Spacer(),
              if (category != null)
                IconButton(
                  key: const ValueKey('clear-transaction-category'),
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  icon: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.onSurface),
                    ),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ),
              const SizedBox(width: 3),
            ]),
          ),
        ),
      ),
    ]);
  }
}
