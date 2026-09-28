import 'package:flutter/material.dart';

class AppResponsiveScope extends StatelessWidget {
  const AppResponsiveScope({required this.child, super.key});

  static const _referencePhoneWidth = 390.0;
  static const _designViewportWidth = 402.0;
  static const _designTextScale = _designViewportWidth / _referencePhoneWidth;
  static const _maximumAccessibilityScale = 1.2;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final systemScale = mediaQuery.textScaler.scale(1).clamp(
          1.0,
          _maximumAccessibilityScale,
        );
    final scale =
        systemScale > _designTextScale ? systemScale : _designTextScale;
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    );
  }
}
