import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:flutter/material.dart';

class SettingsSelectionIndicator extends StatelessWidget {
  const SettingsSelectionIndicator({
    required this.selected,
    this.loading = false,
    super.key,
  });

  final bool selected;
  final bool loading;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 22,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(milliseconds: 160),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: loading
              ? SizedBox.square(
                  key: const ValueKey('loading'),
                  dimension: 18,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onSurface,
                    strokeWidth: 2,
                  ),
                )
              : selected
                  ? _SelectedMark(key: const ValueKey('selected'))
                  : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      );
}

class _SelectedMark extends StatelessWidget {
  const _SelectedMark({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.onSurface,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            color: AppIconForeground.resolve(context, colors.surface),
            shadows: Theme.of(context).brightness == Brightness.dark
                ? [Shadow(color: colors.surface, blurRadius: 4)]
                : null,
            size: 15,
          ),
        ),
      ),
    );
  }
}
