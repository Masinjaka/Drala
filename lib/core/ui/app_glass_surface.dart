import 'package:flutter/material.dart';
import 'app_glass_theme.dart';
import 'app_glass_backdrop.dart';

enum AppGlassEdge { none, top, bottom }

/// Page areas use background fades; the floating navigation pill retains blur.
class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface(
      {required this.child,
      this.active = true,
      this.navigation = false,
      this.footerTail,
      this.radius = BorderRadius.zero,
      this.edge = AppGlassEdge.none,
      super.key});
  final Widget child;
  final bool active;
  final bool navigation;
  final double? footerTail;
  final BorderRadius radius;
  final AppGlassEdge edge;

  @override
  Widget build(BuildContext context) {
    if (edge == AppGlassEdge.none || navigation) {
      return ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: AppGlassTheme.filter,
          child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppGlassTheme.tint(context, navigation: navigation),
                borderRadius: radius,
                border: navigation
                    ? Border.all(color: AppGlassTheme.border(context))
                    : null,
              ),
              child: child),
        ),
      );
    }
    final top = edge == AppGlassEdge.top;
    return Stack(fit: StackFit.passthrough, clipBehavior: Clip.none, children: [
      Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: IgnorePointer(
            child: TweenAnimationBuilder<double>(
          tween: Tween(end: active ? 1.0 : 0.0),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, amount, child) => AppGlassBackdrop(
              top: top, amount: amount, footerTail: footerTail),
        )),
      ),
      child,
    ]);
  }
}
