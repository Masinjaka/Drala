import 'package:flutter/material.dart';
import 'app_glass_theme.dart';

/// Fades page chrome to the page background without filtering its controls.
class AppGlassBackdrop extends StatelessWidget {
  const AppGlassBackdrop({
    required this.top,
    required this.amount,
    this.footerTail,
    super.key,
  });
  final bool top;
  final double amount;
  final double? footerTail;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGlassTheme.pageFade(
              context,
              height: constraints.maxHeight,
              top: top,
              amount: amount,
              footerTail: footerTail,
            ),
          ),
        ),
      );
}
