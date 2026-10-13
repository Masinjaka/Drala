import 'package:budgets/core/ui/app_navigation_theme.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final animationDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180);
    final labels = [
      context.l10n.activities,
      context.l10n.envelope,
      context.l10n.reports,
      context.l10n.profile
    ];
    const assets = ['activities', 'envelope', 'reports', 'profile'];
    // Figma 795:42: label centers at 58, 160, 254.5 and 347 on a 412px frame.
    const centers = [58.0, 160.0, 254.5, 347.0];
    const widths = [56.0, 56.0, 49.0, 58.0];
    const iconOffsets = [12.67, 12.25, 11.25, 11.25];
    return Material(
      color: AppNavigationTheme.background(context),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: SizedBox(
          height: 57,
          child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                    children: List.generate(4, (index) {
                      final selected = index == selectedIndex;
                      return Positioned(
                        left: centers[index] / 412 * constraints.maxWidth -
                            widths[index] / 2,
                        top: 0,
                        bottom: 0,
                        width: widths[index],
                        child: Semantics(
                          button: true,
                          selected: selected,
                          label: labels[index],
                          excludeSemantics: true,
                          child: GestureDetector(
                            key: ValueKey('home-navigation-$index'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onSelected(index),
                            child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: iconOffsets[index],
                                    child: AnimatedScale(
                                      key: ValueKey(
                                          'home-navigation-icon-$index'),
                                      scale: selected ? 1.18 : 1,
                                      duration: animationDuration,
                                      curve: Curves.easeOutBack,
                                      child: AnimatedSwitcher(
                                        duration: animationDuration,
                                        switchInCurve: Curves.easeOut,
                                        switchOutCurve: Curves.easeIn,
                                        transitionBuilder: (child, animation) =>
                                            FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: Tween<double>(
                                              begin: .92,
                                              end: 1,
                                            ).animate(animation),
                                            child: child,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/navigation/${assets[index]}${selected ? '_filled' : ''}.svg',
                                          key: ValueKey(
                                              'home-navigation-icon-$index-$selected'),
                                          colorFilter: ColorFilter.mode(
                                            AppNavigationTheme.icon(context,
                                                selected: selected),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 34,
                                    left: 0,
                                    right: 0,
                                    child: Text(
                                      labels[index],
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppNavigationTheme.label(context,
                                          index: index, selected: selected),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    }),
                  )),
        ),
      ),
    );
  }
}
