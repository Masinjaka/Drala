import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class DrawerMenuSection extends StatelessWidget {
  const DrawerMenuSection({
    required this.onEnvelopePressed,
    required this.onStatsPressed,
    required this.onWalletsPressed,
    required this.onCategoriesPressed,
    super.key,
  });

  final VoidCallback onEnvelopePressed;
  final VoidCallback onStatsPressed;
  final VoidCallback onWalletsPressed;
  final VoidCallback onCategoriesPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _item(context, Icons.mail_outline_rounded, context.l10n.envelope,
            const Key('drawer-envelope-button'), onEnvelopePressed),
        _item(context, Icons.pie_chart_outline_rounded, context.l10n.stats,
            const Key('drawer-stats-button'), onStatsPressed),
        _item(
            context,
            Icons.account_balance_wallet_outlined,
            context.l10n.wallets,
            const Key('drawer-wallets-button'),
            onWalletsPressed),
        _item(context, Icons.category_outlined, context.l10n.categories,
            const Key('drawer-categories-button'), onCategoriesPressed),
      ],
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, Key key,
      VoidCallback onTap) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.only(left: 29),
          child: Row(
            children: [
              SizedBox(width: 22, child: Icon(icon, size: 22)),
              const SizedBox(width: 11),
              Text(label, style: AppTextTheme.drawerMenu(context)),
            ],
          ),
        ),
      ),
    );
  }
}
