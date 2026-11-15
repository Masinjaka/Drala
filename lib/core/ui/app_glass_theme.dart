import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_navigation_theme.dart';
import 'app_header_metrics.dart';

abstract final class AppGlassTheme {
  static final _headerFadeWeights = List<double>.generate(25, (i) {
    final x = i / 24;
    return x * x * x * (x * (x * 6 - 15) + 10);
  }, growable: false);
  static LinearGradient pageFade(BuildContext context,
      {required double height,
      required bool top,
      required double amount,
      double? footerTail}) {
    final background = Scaffold.maybeOf(context)?.widget.backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor;
    if (top) {
      if (footerTail != null && footerTail > 0 && footerTail < height) {
        final pillEnd = 1 - footerTail / height;
        const pillEndOpacity = .18;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            for (final weight in _headerFadeWeights)
              background.withValues(alpha: amount * pillEndOpacity * weight),
            for (final weight in _headerFadeWeights.skip(1))
              background.withValues(
                  alpha: amount *
                      (pillEndOpacity + (1 - pillEndOpacity) * weight)),
          ],
          stops: [
            for (var i = 0; i < _headerFadeWeights.length; i++)
              pillEnd * i / 24,
            for (var i = 1; i < _headerFadeWeights.length; i++)
              pillEnd + (1 - pillEnd) * i / 24,
          ],
        );
      }
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          background.withValues(alpha: 0),
          background.withValues(alpha: amount),
          background.withValues(alpha: amount)
        ],
        stops: const [0, .9, 1],
      );
    }
    // A quintic smoothstep has zero slope and curvature at both ends. Spread
    // it across one control height so it joins clear content without a band.
    final span = (AppHeaderMetrics.buttonSize / height).clamp(0.0, 1.0);
    final weights = _headerFadeWeights;
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        for (final weight in weights)
          background.withValues(alpha: amount * weight),
        background.withValues(alpha: amount)
      ],
      stops: [for (var i = 0; i < weights.length; i++) span * i / 24, 1],
    );
  }

  static final filter = ImageFilter.blur(sigmaX: 18, sigmaY: 18);
  static Color tint(BuildContext context, {bool navigation = false}) {
    final contrast = MediaQuery.highContrastOf(context);
    if (navigation) {
      return AppNavigationTheme.barBackground(context)
          .withValues(alpha: contrast ? .94 : .66);
    }
    final base = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Theme.of(context).colorScheme.surface;
    return base.withValues(alpha: contrast ? .96 : .72);
  }

  static Color border(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: .08);
}
