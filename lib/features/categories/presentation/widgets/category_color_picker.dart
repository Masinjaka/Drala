import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_sheet_route.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_reference_layout.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_form_actions.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class CategoryColorPicker extends StatefulWidget {
  const CategoryColorPicker({required this.color, super.key});
  final Color color;
  static Future<Color?> show(BuildContext context, Color color) =>
      showTransactionFormSheet<Color>(context,
          builder: (_) => CategoryColorPicker(color: color));
  @override
  State<CategoryColorPicker> createState() => _CategoryColorPickerState();
}

class _CategoryColorPickerState extends State<CategoryColorPicker> {
  final _pages = PageController();
  late Color _color = widget.color;
  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TransactionSheetSurface(
          referenceStyle: true,
          pageController: _pages,
          pages: [
            TransactionReferenceLayout(
                actions: TransactionFormActions(
                    saving: false,
                    onSave: () => Navigator.pop(context, _color),
                    onCancel: () => Navigator.pop(context)),
                children: [
                  TransactionFormHeader(
                      title: context.l10n.chooseCategoryColor,
                      onClose: () => Navigator.pop(context)),
                  const SizedBox(height: 24),
                  ColorPicker(
                      color: _color,
                      onColorChanged: (value) => setState(() => _color = value),
                      wheelDiameter: 220,
                      pickersEnabled: const {
                        ColorPickerType.primary: false,
                        ColorPickerType.accent: false,
                        ColorPickerType.wheel: true,
                      }),
                ])
          ]);
}
