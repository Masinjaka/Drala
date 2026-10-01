import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeOperationLoadingField extends StatelessWidget {
  const HomeOperationLoadingField({
    required this.isLoading,
    required this.child,
    this.isCircle = false,
    super.key,
  });

  final bool isLoading;
  final bool isCircle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: child,
        ),
        Positioned.fill(
          child: Shimmer.fromColors(
            baseColor: colors.surfaceContainerHighest,
            highlightColor: colors.surfaceContainerLowest,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isCircle ? null : BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
