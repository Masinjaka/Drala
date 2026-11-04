import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:flutter/material.dart';

class AppCardSurface extends StatelessWidget {
  const AppCardSurface({
    required this.child,
    this.color,
    this.shape,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.showShadow = true,
    super.key,
  }) : assert(shape == null || borderRadius == null);

  final Widget child;
  final Color? color;
  final ShapeBorder? shape;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final outline = shape ??
        RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.zero);
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: outline,
        shadows: showShadow ? AppCardTheme.shadows(context) : const [],
      ),
      child: Material(
        color: color,
        shape: shape,
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}
