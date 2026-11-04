import 'package:budgets/core/ui/app_sheet_header.dart';
import 'package:flutter/material.dart';

class TransactionFormHeader extends StatelessWidget {
  const TransactionFormHeader(
      {super.key,
      required this.title,
      required this.onClose,
      this.showTitle = true,
      this.deleteKey,
      this.showDelete = false,
      this.onDelete});
  final String title;
  final VoidCallback onClose;
  final bool showTitle;
  final VoidCallback? onDelete;
  final Key? deleteKey;
  final bool showDelete;

  @override
  Widget build(BuildContext context) => AppSheetHeader(
        title: title,
        onClose: onClose,
        showTitle: showTitle,
        onDelete: onDelete,
        showDelete: showDelete,
        deleteKey: deleteKey,
        closeKey: const Key('close-transaction-sheet'),
      );
}
