import 'package:flutter/material.dart';

class EmptyStateIllustration extends StatelessWidget {
  const EmptyStateIllustration({
    this.width = 180,
    this.asset = 'assets/illustrations/empty-budgeting.png',
    this.lineArt = false,
    super.key,
  });

  final double width;
  final String asset;
  final bool lineArt;

  @override
  Widget build(BuildContext context) => Image.asset(
        asset,
        width: width,
        height: lineArt ? width : width * 2 / 3,
        fit: BoxFit.contain,
        cacheWidth: (width * 3).round(),
        filterQuality: FilterQuality.low,
        color: lineArt ? Theme.of(context).colorScheme.onSurfaceVariant : null,
        colorBlendMode: lineArt ? BlendMode.srcIn : null,
        excludeFromSemantics: true,
      );
}
