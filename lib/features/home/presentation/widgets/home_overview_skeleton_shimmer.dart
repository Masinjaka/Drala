import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeOverviewSkeletonShimmer extends StatelessWidget {
  const HomeOverviewSkeletonShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: Shimmer.fromColors(
        enabled: !MediaQuery.disableAnimationsOf(context),
        period: const Duration(milliseconds: 1100),
        baseColor: colors.surfaceBright,
        highlightColor: colors.surfaceContainerHigh,
        child: child,
      ),
    );
  }
}
