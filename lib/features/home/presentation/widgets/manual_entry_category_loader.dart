import 'package:budgets/core/ui/app_loader.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_category_field.dart';
import 'package:flutter/material.dart';

class ManualEntryCategoryLoader extends StatelessWidget {
  const ManualEntryCategoryLoader({
    required this.categories,
    required this.transactionType,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Future<List<ManualEntryCategory>> categories;
  final String transactionType;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ManualEntryCategory>>(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const _CategoryLoadError();
        if (!snapshot.hasData) return const _CategoryLoadingState();
        final filtered = snapshot.data!
            .where(
              (category) => category.transactionType == transactionType,
            )
            .toList(growable: false);
        return ManualEntryCategoryField(
          categories: filtered,
          value: value,
          onChanged: onChanged,
        );
      },
    );
  }
}

class _CategoryLoadingState extends StatelessWidget {
  const _CategoryLoadingState();

  @override
  Widget build(BuildContext context) {
    return const _CategoryStatus(child: AppLoader.small());
  }
}

class _CategoryLoadError extends StatelessWidget {
  const _CategoryLoadError();

  @override
  Widget build(BuildContext context) {
    return const _CategoryStatus(
      child: Text(
        'Could not load categories',
        style: AppTextStyle(AppTextRole.supporting),
      ),
    );
  }
}

class _CategoryStatus extends StatelessWidget {
  const _CategoryStatus({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: AppTextStyle(AppTextRole.body),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: ManualEntryCategoryField.cardHeight,
          child: Align(alignment: Alignment.centerLeft, child: child),
        ),
      ],
    );
  }
}
