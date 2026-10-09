import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/home/presentation/widgets/drawer_menu_section.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    required this.width,
    required this.onEnvelopePressed,
    required this.onStatsPressed,
    required this.onWalletsPressed,
    required this.onCategoriesPressed,
    required this.onSettingsPressed,
    required this.onCollapsePressed,
    super.key,
  });

  final double width;
  final VoidCallback onEnvelopePressed;
  final VoidCallback onStatsPressed;
  final VoidCallback onWalletsPressed;
  final VoidCallback onCategoriesPressed;
  final Future<void> Function() onSettingsPressed;
  final VoidCallback onCollapsePressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 32),
          child: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 29),
                  child: OutlinedSquareButton(
                    key: const Key('collapse-sidebar-button'),
                    icon: Icons.arrow_back_rounded,
                    onPressed: onCollapsePressed,
                  ),
                ),
                const SizedBox(height: 9),
                DrawerMenuSection(
                  onEnvelopePressed: onEnvelopePressed,
                  onStatsPressed: onStatsPressed,
                  onWalletsPressed: onWalletsPressed,
                  onCategoriesPressed: onCategoriesPressed,
                ),
                const Spacer(),
                InkWell(
                  key: const Key('drawer-settings-button'),
                  onTap: onSettingsPressed,
                  child: SizedBox(
                    height: 36,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 29),
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 22,
                              child: Icon(Icons.settings_outlined, size: 22)),
                          const SizedBox(width: 11),
                          Text(context.l10n.settings,
                              style: AppTextTheme.drawerMenu(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
