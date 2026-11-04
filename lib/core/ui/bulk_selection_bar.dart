import 'package:budgets/core/ui/app_delete_button.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class BulkSelectionBar extends StatelessWidget {
  const BulkSelectionBar(
      {required this.selecting,
      required this.count,
      required this.onSelect,
      required this.onCancel,
      required this.onDelete,
      this.busy = false,
      super.key});
  final bool selecting;
  final int count;
  final bool busy;
  final VoidCallback onSelect;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    if (!selecting) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: TextButton.icon(
            key: const Key('select-items'),
            onPressed: onSelect,
            icon: const Icon(Icons.checklist_rounded, size: 20),
            label: Text(context.l10n.selectItems,
                style: Theme.of(context).textTheme.bodySmall)),
      );
    }
    return Row(children: [
      TextButton(
          key: const Key('cancel-selection'),
          onPressed: busy ? null : onCancel,
          child: Text(context.l10n.cancel,
              style: Theme.of(context).textTheme.bodySmall)),
      Expanded(
          child: Text(context.l10n.selectedItemCount(count),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall)),
      AppDeleteButton(
          key: const Key('delete-selected-items'),
          tooltip: context.l10n.deleteSelectedItems,
          onPressed: busy || count == 0 ? null : onDelete,
          busy: busy),
    ]);
  }
}
