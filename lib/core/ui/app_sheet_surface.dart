import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppSheetSurface extends StatelessWidget {
  const AppSheetSurface({
    required this.child,
    this.height,
    this.heightFactor,
    this.keyboardAware = false,
    this.surfaceKey = const ValueKey('app-sheet-surface'),
    super.key,
  }) : assert(height != null || heightFactor != null);

  final Widget child;
  final double? height;
  final double? heightFactor;
  final bool keyboardAware;
  final Key surfaceKey;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = keyboardAware ? mediaQuery.viewInsets.bottom : 0.0;
    final bottomSafeArea = mediaQuery.viewPadding.bottom;
    final keyboardOffset = keyboardHeight > 0
        ? (keyboardHeight + 12 - bottomSafeArea).clamp(0.0, double.infinity)
        : 0.0;
    final availableHeight =
        mediaQuery.size.height - mediaQuery.padding.vertical;
    final resolvedHeight = height == null
        ? availableHeight * heightFactor!
        : math.min(height!, availableHeight - 24);

    return SafeArea(
      top: false,
      maintainBottomViewPadding: keyboardHeight > 0,
      child: Transform.translate(
        offset: Offset(0, -keyboardOffset),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: resolvedHeight,
              width: double.infinity,
              child: Container(
                key: surfaceKey,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).shadowColor.withValues(alpha: .15),
                      blurRadius: 28,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(color: Colors.transparent, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
