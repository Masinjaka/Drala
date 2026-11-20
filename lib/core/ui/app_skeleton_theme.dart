import 'package:flutter/material.dart';

/// Shared shimmer tokens for skeleton placeholders.
abstract final class AppSkeletonTheme {
  static const period = Duration(milliseconds: 1100);

  static Color base(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: .07);

  static Color highlight(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: .16);

  static Color fill(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
}
