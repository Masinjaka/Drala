import 'dart:math' as math;

import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/ui/app_interaction_theme.dart';
import 'package:budgets/core/ui/app_glass_surface.dart';
import 'package:budgets/features/home/presentation/widgets/home_navigation_row.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar(
      {required this.selectedIndex,
      required this.onSelected,
      this.composer,
      this.notice,
      super.key});
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget? composer;
  final Widget? notice;
  static const _bottomPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final expanded = selectedIndex == 1 && composer != null;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final duration =
        reducedMotion ? Duration.zero : const Duration(milliseconds: 360);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return Theme(
        data: AppInteractionTheme.withoutInkFeedback(context),
        child: AppGlassSurface(
            edge: AppGlassEdge.top,
            footerTail: selectedIndex == 0
                ? keyboardInset +
                    math.max(
                        MediaQuery.paddingOf(context).bottom, _bottomPadding)
                : null,
            child: Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(top: 8, bottom: _bottomPadding),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: expanded ? 1 : 0),
                  duration: duration,
                  curve: Curves.easeInOutCubic,
                  child: composer,
                  builder: (context, progress, child) {
                    final inset = AppPageSpacing.horizontal(context);
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: inset - (inset - 16) * progress),
                      child: Center(
                          heightFactor: 1,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: AppGlassSurface(
                              key: const Key('home-navigation-surface'),
                              navigation: true,
                              radius: BorderRadius.circular(32 - 10 * progress),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(6 + 8 * progress,
                                    6 + 4 * progress, 6 + 8 * progress, 6),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (child != null)
                                        ClipRect(
                                            child: Align(
                                          alignment: Alignment.bottomCenter,
                                          heightFactor: progress,
                                          child: Offstage(
                                              offstage: progress == 0,
                                              child: ExcludeFocus(
                                                  excluding: !expanded,
                                                  child: ExcludeSemantics(
                                                      excluding: !expanded,
                                                      child: IgnorePointer(
                                                          ignoring: !expanded,
                                                          child: TickerMode(
                                                              enabled: expanded,
                                                              child: Opacity(
                                                                  opacity:
                                                                      progress,
                                                                  child: Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              16),
                                                                      child:
                                                                          child))))))),
                                        )),
                                      if (selectedIndex == 1 && notice != null)
                                        notice!,
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14 * progress),
                                          child: HomeNavigationRow(
                                              selectedIndex: selectedIndex,
                                              onSelected: onSelected,
                                              duration: duration)),
                                    ]),
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ),
            )));
  }
}
