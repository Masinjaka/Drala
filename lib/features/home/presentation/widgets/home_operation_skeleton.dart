import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeOperationSkeleton extends StatelessWidget {
  const HomeOperationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceBright;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: theme.colorScheme.surfaceContainerHigh,
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(dimension: 40),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(64, 13, baseColor),
                  const SizedBox(height: 9),
                  _bar(93, 10, baseColor),
                ],
              ),
            ),
            _bar(46, 14, baseColor),
          ],
        ),
      ),
    );
  }

  Widget _bar(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
