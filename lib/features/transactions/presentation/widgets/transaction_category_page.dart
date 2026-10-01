import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_category_chip.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class TransactionCategoryPage extends StatefulWidget {
  const TransactionCategoryPage({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
    required this.onBack,
  });

  final List<Category> categories;
  final Category? selected;
  final ValueChanged<Category> onSelected;
  final VoidCallback onBack;

  @override
  State<TransactionCategoryPage> createState() =>
      _TransactionCategoryPageState();
}

class _TransactionCategoryPageState extends State<TransactionCategoryPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = widget.categories.where((category) {
      return (category.name ?? '').toLowerCase().contains(query);
    }).toList(growable: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          IconButton(
            key: const ValueKey('category-back'),
            onPressed: widget.onBack,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            icon: const Icon(Icons.arrow_back, size: 19),
          ),
          const SizedBox(width: 4),
          Text(context.l10n.categories,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 19),
        TextField(
          key: const ValueKey('category-search'),
          controller: _searchController,
          cursorColor: Theme.of(context).colorScheme.onSurface,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            hintText: context.l10n.searchCategories,
            prefixIcon: const Icon(Icons.search, size: 18),
            prefixIconConstraints: const BoxConstraints(minWidth: 42),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 9,
          children: filtered.map((category) {
            final selected = category.id != null
                ? category.id == widget.selected?.id
                : category.name == widget.selected?.name;
            return TransactionCategoryChip(
              category: category,
              selected: selected,
              onTap: () => widget.onSelected(category),
            );
          }).toList(growable: false),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton(
            key: const ValueKey('category-done'),
            onPressed: widget.onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: Text(context.l10n.done,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }
}
