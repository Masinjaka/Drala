import 'package:flutter/material.dart';
import 'package:budgets/l10n/app_localizations_context.dart';

class ReceiptPageCount extends StatelessWidget {
  const ReceiptPageCount({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: const StadiumBorder(),
        ),
        child: Text(
          context.l10n.pageCount(count),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
}
