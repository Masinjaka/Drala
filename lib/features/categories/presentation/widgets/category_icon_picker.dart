import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:budgets/core/ui/app_sheet_route.dart';
import 'package:budgets/core/ui/app_sheet_surface.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/core/ui/app_category_icon_theme.dart';
import 'package:budgets/core/ui/category_icon_labels.dart';
import 'package:budgets/core/ui/category_icons.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon_option.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class CategoryIconPicker extends StatefulWidget {
  const CategoryIconPicker({this.selected = 'other', this.colorHex, super.key});
  final String selected;
  final String? colorHex;

  static Future<String?> show(BuildContext context,
          {String selected = 'other', String? colorHex}) =>
      showAppSheet<String>(context,
          builder: (_) => AppSheetSurface(
              heightFactor: .7,
              keyboardAware: true,
              child:
                  CategoryIconPicker(selected: selected, colorHex: colorHex)));

  @override
  State<CategoryIconPicker> createState() => _CategoryIconPickerState();
}

class _CategoryIconPickerState extends State<CategoryIconPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final icons = CategoryIcons.all.keys
        .where((key) =>
            CategoryIconLabels.label(l10n, key).toLowerCase().contains(_query))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppSheetHeader(
            title: l10n.chooseCategoryIcon,
            onClose: () => Navigator.pop(context)),
        const SizedBox(height: 8),
        TextField(
            key: const Key('category-icon-search'),
            style: AppCategoryIconTheme.search(context),
            decoration: AppFinanceSurfaceTheme.input(context,
                hint: l10n.searchCategoryIcons,
                prefix: const Icon(Icons.search)),
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase())),
        const SizedBox(height: 16),
        Expanded(
            child: GridView.builder(
          key: const Key('category-icon-grid'),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 112,
              mainAxisExtent: 104,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8),
          itemCount: icons.length,
          itemBuilder: (_, index) {
            final key = icons[index];
            return CategoryIconOption(
                iconKey: key,
                colorHex: widget.colorHex,
                label: CategoryIconLabels.label(l10n, key),
                selected: widget.selected == key,
                onTap: () => Navigator.pop(context, key));
          },
        )),
      ]),
    );
  }
}
