import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsMenuIcon extends StatelessWidget {
  const SettingsMenuIcon({required this.asset, super.key});

  final String asset;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 35,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/settings/menu_icon_background.svg',
              colorFilter: ColorFilter.mode(
                AppSettingsTheme.iconSurface(context),
                BlendMode.srcIn,
              ),
            ),
            SvgPicture.asset(
              asset,
              colorFilter: ColorFilter.mode(
                AppSettingsTheme.iconForeground(context),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      );
}
