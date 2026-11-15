import 'package:budgets/core/ui/app_header_button_shadow.dart';
import 'package:budgets/core/ui/app_finance_surface_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_delete_button.dart';
import 'package:budgets/core/ui/app_close_button.dart';

class WalletPageHeader extends StatelessWidget {
  const WalletPageHeader({
    this.onSelect,
    this.onDelete,
    this.selecting = false,
    this.busy = false,
    super.key,
  });
  final VoidCallback? onSelect;
  final VoidCallback? onDelete;
  final bool selecting;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final buttonStyle = AppFinanceSurfaceTheme.headerButton(context);
    return Row(children: [
      Expanded(
          child: Text(context.l10n.wallets,
              style: AppFinanceSurfaceTheme.title(context))),
      if (onSelect != null) ...[
        AppHeaderButtonShadow(
            child: IconButton.filledTonal(
                key: const Key('select-items'),
                onPressed: onSelect,
                tooltip: context.l10n.selectItems,
                style: buttonStyle,
                icon: const Icon(Icons.checklist_rounded, size: 20))),
        const SizedBox(width: 8),
      ],
      if (selecting) ...[
        AppDeleteButton(
            key: const Key('delete-selected-items'),
            onPressed: onDelete,
            tooltip: context.l10n.deleteSelectedItems,
            busy: busy),
        const SizedBox(width: 8),
      ],
      AppCloseButton(
          key: const Key('wallet-page-close'),
          onPressed: () => Navigator.maybePop(context)),
    ]);
  }
}
