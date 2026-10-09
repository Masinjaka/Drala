import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:budgets/features/transactions/presentation/widgets/transaction_sheet_surface.dart';
import 'package:flutter/material.dart';

class SettingsEditorSheet extends StatefulWidget {
  const SettingsEditorSheet({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  State<SettingsEditorSheet> createState() => _SettingsEditorSheetState();
}

class _SettingsEditorSheetState extends State<SettingsEditorSheet> {
  final _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TransactionSheetSurface(
        pageController: _pages,
        pages: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: TransactionFormHeader(
                title: widget.title,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(child: widget.child),
          ])
        ],
      );
}
