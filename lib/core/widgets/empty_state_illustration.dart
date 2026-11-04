import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_empty_state_theme.dart';

class EmptyStateIllustration extends StatelessWidget {
  const EmptyStateIllustration({
    this.width = AppEmptyStateTheme.illustrationWidth,
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
        cacheWidth:
            (width * MediaQuery.devicePixelRatioOf(context).clamp(1, 3)).ceil(),
        filterQuality: FilterQuality.low,
        color: lineArt ? Theme.of(context).colorScheme.onSurfaceVariant : null,
        colorBlendMode: lineArt ? BlendMode.srcIn : null,
        excludeFromSemantics: true,
      );
}
