import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.iconAsset,
    this.trailing,
    this.height = 51,
    super.key,
  }) : assert(icon != null || iconAsset != null);

  final String title;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onTap;
  final Widget? trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: iconAsset == null ? _standardItem(context) : _figmaItem(context),
      ),
    );
  }

  Widget _figmaItem(BuildContext context) => Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: SettingsMenuIcon(asset: iconAsset!),
          ),
          Positioned(
            left: 52,
            right: 20,
            top: 9,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppSettingsTheme.menuLabel(context),
            ),
          ),
          Positioned(
            right: 0,
            top: 10.5,
            child: trailing ?? _assetChevron(context),
          ),
        ],
      );

  Widget _standardItem(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: Row(
          children: [
            Icon(icon, size: 19),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right, size: 28),
          ],
        ),
      );

  Widget _assetChevron(BuildContext context) => SvgPicture.asset(
        'assets/settings/chevron.svg',
        colorFilter: ColorFilter.mode(
          AppSettingsTheme.foreground(context),
          BlendMode.srcIn,
        ),
      );
}
