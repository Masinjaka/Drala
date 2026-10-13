import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:flutter/material.dart';

class TransactionFormHeader extends StatelessWidget {
  const TransactionFormHeader(
      {super.key, required this.title, required this.onClose});
  final String title;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) => AppSheetHeader(
        title: title,
        onClose: onClose,
        closeKey: const ValueKey('close-transaction-sheet'),
      );
}
