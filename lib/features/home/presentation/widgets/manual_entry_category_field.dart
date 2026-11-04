import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_category_content.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:flutter/material.dart';

class ManualEntryCategoryField extends StatelessWidget {
  const ManualEntryCategoryField({
    required this.categories,
    required this.value,
    required this.onChanged,
    this.label = 'Category',
    super.key,
  });

  final List<ManualEntryCategory> categories;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;

  static const cardWidth = 108.0;
  static const cardHeight = 82.0;
  static const selectedScale = 1.04;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const AppTextStyle(AppTextRole.body),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: cardHeight,
          child: categories.isEmpty
              ? _emptyCategory(context)
              : ListView.separated(
                  key: const Key('manual-category-list'),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 7),
                  itemBuilder: (_, index) =>
                      _categoryCard(context, categories[index]),
                ),
        ),
      ],
    );
  }

  Widget _emptyCategory(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          boxShadow: AppCardTheme.shadows(context),
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
        ),
        child: const ManualEntryCategoryContent(
          emoji: '🧾',
          name: 'Other',
          selected: false,
        ),
      ),
    );
  }

  Widget _categoryCard(
    BuildContext context,
    ManualEntryCategory category,
  ) {
    final selected = value == category.id;
    final backgroundColor = Theme.of(context).cardColor;
    return Align(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        scale: selected ? selectedScale : 1,
        child: Semantics(
          selected: selected,
          button: true,
          child: InkWell(
            key: Key('manual-category-${category.id}'),
            borderRadius: BorderRadius.circular(17),
            onTap: () => onChanged(category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                boxShadow: AppCardTheme.shadows(context),
                color: backgroundColor,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: selected
                      ? _selectedBorder(context, backgroundColor)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ManualEntryCategoryContent(
                emoji: category.emoji,
                iconKey: category.iconKey,
                colorHex: category.colorHex,
                name: category.name,
                selected: selected,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _selectedBorder(BuildContext context, Color background) => Color.lerp(
        background,
        Theme.of(context).colorScheme.inverseSurface,
        0.32,
      )!;
}
