import 'package:budgets/core/ui/app_loader.dart';
import 'settings_selected_mark.dart';
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
              ? const AppLoader(key: ValueKey('loading'), size: 22)
              : selected
                  ? SettingsSelectedMark(key: const ValueKey('selected'))
                  : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      );
}
