import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ValueSkeleton extends StatelessWidget {
  const ValueSkeleton({this.width = 80, this.height = 24, super.key});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExcludeSemantics(
        child: Shimmer.fromColors(
      period: const Duration(milliseconds: 1100),
      baseColor: colors.onSurface.withValues(alpha: .07),
      highlightColor: colors.onSurface.withValues(alpha: .16),
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: colors.onSurface, borderRadius: BorderRadius.circular(6))),
    ));
  }
}
