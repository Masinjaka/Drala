import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SettingsSummaryCardType { categories, wallets }

class SettingsSummaryCard extends StatelessWidget {
  const SettingsSummaryCard({
    required this.type,
    required this.title,
    required this.count,
    required this.onTap,
    super.key,
  });

  final SettingsSummaryCardType type;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: type == SettingsSummaryCardType.categories
            ? AppSettingsTheme.categoryCard(context)
            : AppSettingsTheme.walletCard(context),
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 88,
            child: Stack(
              children: [
                Positioned(
                  left: 12,
                  top: 11,
                  child: Text(
                    title,
                    style: AppSettingsTheme.summaryTitle(context),
                  ),
                ),
                Positioned(
                  left: 13,
                  top: 53,
                  child: Text(
                    '$count',
                    style: AppSettingsTheme.summaryCount(context),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 14,
                  child: SvgPicture.asset(
                    'assets/settings/summary_arrow.svg',
                    colorFilter: ColorFilter.mode(
                      AppSettingsTheme.iconForeground(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                ..._decorations(context),
              ],
            ),
          ),
        ),
      );

  List<Widget> _decorations(BuildContext context) =>
      type == SettingsSummaryCardType.categories
          ? [
              _emojiCircle(
                right: -6,
                top: 43,
                asset: 'assets/settings/decor_circle_blue.svg',
                emoji: '🚌',
                angle: .37,
              ),
              Positioned(
                right: 28,
                top: 34,
                child: SvgPicture.asset(
                  'assets/settings/category_pig.svg',
                  width: 25,
                  height: 25,
                  colorFilter: Theme.of(context).brightness == Brightness.dark
                      ? ColorFilter.mode(
                          AppSettingsTheme.iconForeground(context),
                          BlendMode.srcIn,
                        )
                      : null,
                ),
              ),
              _emojiCircle(
                right: 36,
                top: 68,
                asset: 'assets/settings/decor_circle_yellow.svg',
                emoji: '💰',
                angle: -.33,
              ),
              _emojiCircle(
                right: 62,
                top: 63,
                asset: 'assets/settings/decor_circle_large.svg',
                emoji: '🛒',
                size: 29,
                angle: .18,
              ),
            ]
          : [
              _emojiCircle(
                right: -6,
                top: 43,
                asset: 'assets/settings/decor_circle_blue.svg',
                emoji: '🚌',
                angle: .37,
              ),
              _emojiCircle(
                right: 28,
                top: 34,
                asset: 'assets/settings/decor_circle_money.svg',
                emoji: '💰',
              ),
              _emojiCircle(
                right: 36,
                top: 68,
                asset: 'assets/settings/decor_circle_yellow.svg',
                emoji: '💰',
                angle: -.33,
              ),
              _emojiCircle(
                right: 61,
                top: 64,
                asset: 'assets/settings/decor_circle_large.svg',
                emoji: '🛒',
                size: 29,
                angle: .18,
              ),
            ];

  Widget _emojiCircle({
    required double right,
    required double top,
    required String asset,
    required String emoji,
    double size = 20,
    double angle = 0,
  }) =>
      Positioned(
        right: right,
        top: top,
        child: Transform.rotate(
          angle: angle,
          child: SizedBox.square(
            dimension: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(asset, width: size, height: size),
                Text(emoji, style: const TextStyle(fontSize: 12, height: 1)),
              ],
            ),
          ),
        ),
      );
}
