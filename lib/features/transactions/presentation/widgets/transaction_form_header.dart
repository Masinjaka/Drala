import 'package:flutter/material.dart';

class TransactionFormHeader extends StatelessWidget {
  const TransactionFormHeader(
      {super.key, required this.title, required this.onClose});
  final String title;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      IconButton(
        key: const ValueKey('close-transaction-sheet'),
        onPressed: onClose,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        icon: const Icon(Icons.close, size: 20),
      ),
    ]);
  }
}
