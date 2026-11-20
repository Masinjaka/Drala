import 'package:budgets/core/ui/app_control_metrics.dart';
import 'package:budgets/core/ui/app_skeleton_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering placeholder shown in place of a button while its action runs.
class AppButtonSkeleton extends StatelessWidget {
  const AppButtonSkeleton({
    this.width = double.infinity,
    this.height = AppControlMetrics.height,
    this.shape = const StadiumBorder(),
    super.key,
  });

  /// Square/circular icon-button placeholder.
  const AppButtonSkeleton.icon({
    double size = AppControlMetrics.squareButtonVisualSize,
    super.key,
  })  : width = size,
        height = size,
        shape = const CircleBorder();

  final double width;
  final double height;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Shimmer.fromColors(
          enabled: !MediaQuery.disableAnimationsOf(context),
          period: AppSkeletonTheme.period,
          baseColor: AppSkeletonTheme.base(context),
          highlightColor: AppSkeletonTheme.highlight(context),
          child: SizedBox(
            width: width,
            height: height,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppSkeletonTheme.fill(context),
                shape: shape,
              ),
            ),
          ),
        ),
      );
}
