import 'package:flutter/material.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'app_close_button.dart';
import 'app_delete_button.dart';
import 'app_finance_surface_theme.dart';

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader(
      {required this.title,
      required this.onClose,
      this.titleKey,
      this.closeKey = const ValueKey('close-app-sheet'),
      this.showTitle = true,
      this.onDelete,
      this.showDelete = false,
      this.deleteKey,
      super.key});
  final String title;
  final VoidCallback onClose;
  final Key? titleKey;
  final Key closeKey;
  final bool showTitle;
  final VoidCallback? onDelete;
  final bool showDelete;
  final Key? deleteKey;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: showTitle
                ? Text(title,
                    key: titleKey,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFinanceSurfaceTheme.title(context))
                : Semantics(
                    label: title,
                    header: true,
                    child: const SizedBox.shrink())),
        if (onDelete != null || showDelete) ...[
          AppDeleteButton(
              key: deleteKey ?? const Key('delete-transaction'),
              onPressed: onDelete,
              tooltip: context.l10n.delete),
          const SizedBox(width: 8),
        ],
        if (onDelete == null && !showDelete)
          AppCloseButton(key: closeKey, onPressed: onClose),
      ]);
}
