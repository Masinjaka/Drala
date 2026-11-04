import 'package:budgets/features/transactions/presentation/widgets/transaction_form_header.dart';
import 'package:flutter/material.dart';

class ManualEntryFormHeader extends StatelessWidget {
  const ManualEntryFormHeader({
    required this.title,
    required this.selector,
    required this.onClose,
    this.onDelete,
    super.key,
  });

  final String title;
  final Widget selector;
  final VoidCallback onClose;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
        child: Column(children: [
          TransactionFormHeader(
              title: title,
              showTitle: false,
              onClose: onClose,
              onDelete: onDelete),
          const SizedBox(height: 20),
          selector,
        ]),
      );
}
