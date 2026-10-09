import 'package:budgets/core/paths.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/features/onboarding/presentation/widgets/category_bubble.dart';
import 'package:flutter/material.dart';

class CategoryExplosion extends StatefulWidget {
  const CategoryExplosion({this.compactLogo = false, super.key});

  final bool compactLogo;

  @override
  State<CategoryExplosion> createState() => _CategoryExplosionState();
}

class _CategoryExplosionState extends State<CategoryExplosion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();
  bool? _tickerEnabled;

  static const double _logoPhase = .25;

  // Bubble centres are measured against a 320 by 280 illustration canvas.
  static const _bubbles =
      <({double x, double y, double size, int kind, String emoji, double lag})>[
    (x: 147, y: 15, size: 26, kind: 1, emoji: '🎁', lag: .04),
    (x: 77, y: 28, size: 28, kind: 0, emoji: '🛒', lag: .00),
    (x: 220, y: 29, size: 25, kind: 2, emoji: '🍔', lag: .06),
    (x: 184, y: 68, size: 28, kind: 4, emoji: '✈️', lag: .14),
    (x: 238, y: 84, size: 30, kind: 3, emoji: '🎮', lag: .12),
    (x: 117, y: 84, size: 30, kind: 3, emoji: '👕', lag: .10),
    (x: 61, y: 95, size: 26, kind: 2, emoji: '☕', lag: .08),
    (x: 19, y: 130, size: 25, kind: 1, emoji: '💡', lag: .18),
    (x: 90, y: 141, size: 28, kind: 4, emoji: '💊', lag: .02),
    (x: 298, y: 141, size: 28, kind: 0, emoji: '🚗', lag: .20),
    (x: 228, y: 139, size: 26, kind: 5, emoji: '🛍️', lag: .05),
    (x: 78, y: 185, size: 25, kind: 2, emoji: '🎬', lag: .16),
    (x: 131, y: 197, size: 30, kind: 3, emoji: '🏥', lag: .09),
    (x: 196, y: 206, size: 25, kind: 1, emoji: '💰', lag: .12),
    (x: 245, y: 193, size: 30, kind: 3, emoji: '📱', lag: .14),
    (x: 81, y: 257, size: 25, kind: 1, emoji: '📚', lag: .22),
    (x: 157, y: 249, size: 29, kind: 0, emoji: '🚌', lag: .17),
    (x: 229, y: 252, size: 26, kind: 2, emoji: '🏠', lag: .24),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = TickerMode.of(context);
    if (!widget.compactLogo && _tickerEnabled == false && enabled) {
      _controller.forward(from: 0);
    }
    _tickerEnabled = enabled;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: SizedBox(
          width: 320,
          height: 280,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Stack(
              clipBehavior: Clip.none,
              children: [
                for (final bubble in _bubbles) _buildBubble(bubble),
                Positioned(
                  left: widget.compactLogo ? 132 : 125,
                  top: widget.compactLogo ? 120 : 101,
                  child: Opacity(
                    key: const Key('drala-logo-opacity'),
                    opacity: (_controller.value / _logoPhase).clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: .7 +
                          .3 *
                              Curves.easeOutBack.transform(
                                  (_controller.value / _logoPhase)
                                      .clamp(0.0, 1.0)),
                      child: widget.compactLogo
                          ? Image.asset(
                              AppPaths.logo,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 75,
                              height: 75,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Drala',
                                style: AppTextTheme.onboardingWordmark(context),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildBubble(
      ({
        double x,
        double y,
        double size,
        int kind,
        String emoji,
        double lag
      }) bubble) {
    final burstProgress =
        ((_controller.value - _logoPhase) / (1 - _logoPhase)).clamp(0.0, 1.0);
    final fraction =
        ((burstProgress - bubble.lag) / (1 - bubble.lag)).clamp(0.0, 1.0);
    final distance = Curves.easeOutCubic.transform(fraction);
    final x = 162 + (bubble.x - 162) * distance;
    final y = 138 + (bubble.y - 138) * distance;
    return Positioned(
      left: x - bubble.size / 2,
      top: y - bubble.size / 2,
      child: Opacity(
        opacity: fraction,
        child: Transform.scale(
          scale: .25 + .75 * distance,
          child: CategoryBubble(
              kind: bubble.kind, size: bubble.size, emoji: bubble.emoji),
        ),
      ),
    );
  }
}
