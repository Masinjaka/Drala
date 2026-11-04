import 'package:budgets/core/ui/app_navigation_theme.dart';
import 'package:flutter/material.dart';

class HomeNavigationItem extends StatelessWidget {
  const HomeNavigationItem(
      {required this.index,
      required this.label,
      required this.icon,
      required this.selected,
      required this.onPressed,
      required this.duration,
      super.key});
  final int index;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = selected
        ? Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppNavigationTheme.label(context,
                    index: index, selected: selected)),
          )
        : const SizedBox.shrink();
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
          message: label,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              key: ValueKey('home-navigation-$index'),
              onTap: onPressed,
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width < 360 ? 8 : 12,
                    vertical: 12),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(icon,
                      size: 20,
                      color:
                          AppNavigationTheme.icon(context, selected: selected)),
                  Flexible(
                      child: duration == Duration.zero
                          ? selectedLabel
                          : AnimatedSize(
                              duration: duration,
                              curve: Curves.easeInOutCubic,
                              child: selectedLabel)),
                ]),
              ),
            ),
          )),
    );
  }
}
