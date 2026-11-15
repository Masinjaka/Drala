import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_icon.dart';
import 'package:flutter/material.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.title,
    required this.onTap,
    required this.icon,
    this.trailing,
    this.destructive = false,
    this.height = 56,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool destructive;
  final Widget? trailing;
  final double height;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                SettingsMenuIcon(icon: icon),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(title,
                      style: AppSettingsTheme.menuLabel(context,
                          destructive: destructive)),
                ),
                const SizedBox(width: 8),
                trailing ??
                    Icon(Icons.chevron_right_rounded,
                        size: 24,
                        color: AppSettingsTheme.iconForeground(context)),
              ],
            ),
          ),
        ),
      );
}
