import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeOperationSkeleton extends StatelessWidget {
  const HomeOperationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFFF1F1F1);
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: const Color(0xFFFAFAFA),
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            const DecoratedBox(
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
                  _bar(64, 13),
                  const SizedBox(height: 9),
                  _bar(93, 10),
                ],
              ),
            ),
            _bar(46, 14),
          ],
        ),
      ),
    );
  }

  Widget _bar(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
