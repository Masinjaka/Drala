import 'package:budgets/core/ui/app_loader.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

/// Pull-to-refresh that reveals the money-count Lottie instead of the
/// Material spinner. Drop-in replacement for [RefreshIndicator].
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    required this.onRefresh,
    required this.child,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  static const double _extent = 74;
  static const double _loaderSize = 54;

  @override
  Widget build(BuildContext context) => CustomRefreshIndicator(
        onRefresh: onRefresh,
        offsetToArmed: _extent,
        builder: (context, child, controller) {
          final value = controller.value.clamp(0.0, 1.5);
          final offset = value * _extent;
          final visible = !controller.isIdle;
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Transform.translate(offset: Offset(0, offset), child: child),
              if (visible)
                Positioned(
                  top: offset - _loaderSize - (_extent - _loaderSize) / 2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.6 + 0.4 * value.clamp(0.0, 1.0),
                        child: AppLoader(
                          size: _loaderSize,
                          animate: controller.isArmed ||
                              controller.isSettling ||
                              controller.isLoading,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        child: child,
      );
}
