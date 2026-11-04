import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_icon.dart';
import 'package:flutter/material.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.iconAsset,
    this.trailing,
    this.height = 56,
    super.key,
  }) : assert(icon != null || iconAsset != null);

  final String title;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onTap;
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
                if (iconAsset != null)
                  SettingsMenuIcon(asset: iconAsset!)
                else
                  Icon(icon,
                      size: 24,
                      color: AppSettingsTheme.iconForeground(context)),
                const SizedBox(width: 16),
                Expanded(
                  child:
                      Text(title, style: AppSettingsTheme.menuLabel(context)),
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
