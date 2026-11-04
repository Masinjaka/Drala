import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

class SettingsMenuGroup extends StatelessWidget {
  const SettingsMenuGroup({
    required this.items,
    this.flat = false,
    super.key,
  });

  final List<Widget> items;
  final bool flat;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 4),
              child: AppCardSurface(
                color: AppSettingsTheme.surface(context),
                borderRadius: BorderRadius.vertical(
                  top: index == 0
                      ? AppSettingsTheme.outerRadius
                      : AppSettingsTheme.innerRadius,
                  bottom: index == items.length - 1
                      ? AppSettingsTheme.outerRadius
                      : AppSettingsTheme.innerRadius,
                ),
                clipBehavior: Clip.antiAlias,
                child: items[index],
              ),
            ),
        ],
      );
}
