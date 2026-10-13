import 'package:flutter/material.dart';

class SetupCurrencyTrailing extends StatelessWidget {
  const SetupCurrencyTrailing({
    required this.symbol,
    required this.isLoading,
    super.key,
  });

  final String symbol;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(end: isLoading ? 1 : 0),
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(symbol),
          ClipRect(
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: progress,
              child: Opacity(
                opacity: progress,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 2),
                  child: SizedBox.square(
                    dimension: 13,
                    child: CircularProgressIndicator(
                      color: DefaultTextStyle.of(context).style.color,
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
