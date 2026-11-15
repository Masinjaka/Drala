import 'package:flutter/material.dart';

/// A shape in the shared shimmer mask for a Home card or row.
class HomeOverviewSkeletonShape extends StatelessWidget {
  const HomeOverviewSkeletonShape(
      {this.width = 80, required this.height, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(6),
        ),
      );
}
