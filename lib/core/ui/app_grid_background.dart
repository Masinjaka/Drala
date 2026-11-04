import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_grid_theme.dart';
import 'package:flutter/material.dart';
import 'app_grid_painter.dart';

/// A neutral page mesh, optionally attracted toward an amount's render position.
class AppGridBackground extends StatefulWidget {
  const AppGridBackground({
    this.amount = 0,
    this.loading = false,
    this.gravity = false,
    this.backgroundColor,
    this.builder,
    this.child,
    super.key,
  }) : assert((builder == null) != (child == null));

  final num amount;
  final bool loading;
  final bool gravity;
  final Color? backgroundColor;
  final Widget Function(GlobalKey amountKey)? builder;
  final Widget? child;

  @override
  State<AppGridBackground> createState() => _AppGridBackgroundState();
}

class _AppGridBackgroundState extends State<AppGridBackground>
    with SingleTickerProviderStateMixin {
  final _surfaceKey = GlobalKey();
  final _amountKey = GlobalKey();
  final _center = ValueNotifier<Offset>(Offset.zero);
  AnimationController? _mass;
  double? _target;
  bool _measurementScheduled = false;

  void _measure() {
    if (!widget.gravity || _measurementScheduled) return;
    _measurementScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurementScheduled = false;
      if (!mounted) return;
      final surface = _surfaceKey.currentContext?.findRenderObject();
      final amount = _amountKey.currentContext?.findRenderObject();
      if (surface is! RenderBox || amount is! RenderBox || !amount.hasSize) {
        return;
      }
      final position = amount.localToGlobal(amount.size.center(Offset.zero),
          ancestor: surface);
      if ((_center.value - position).distance > .1) _center.value = position;
    });
  }

  @override
  void dispose() {
    _mass?.dispose();
    _center.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible =
        !widget.gravity || AmountVisibilityScope.isVisibleOf(context);
    final target = widget.loading || !visible || !widget.gravity
        ? 0.0
        : AppGridPainter.strengthFor(widget.amount);
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (widget.gravity) {
      final mass = _mass ??= AnimationController(vsync: this);
      if (target != _target || (reducedMotion && mass.isAnimating)) {
        _target = target;
        if (reducedMotion || !visible) {
          mass.value = target;
        } else {
          mass.animateTo(target,
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOutCubic);
        }
      }
    } else {
      _mass?.stop();
      _target = null;
    }
    _measure();
    final background =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return ColoredBox(
      color: background,
      child: LayoutBuilder(builder: (context, constraints) {
        if (!widget.gravity || _center.value == Offset.zero) {
          _center.value =
              Offset(constraints.maxWidth / 2, constraints.maxHeight * .22);
        }
        _measure();
        return NotificationListener<ScrollNotification>(
          onNotification: (_) {
            _measure();
            return false;
          },
          child: Stack(key: _surfaceKey, fit: StackFit.expand, children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: constraints.maxHeight * .55,
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      key: const Key('app-page-grid'),
                      painter: AppGridPainter(
                          mass: widget.gravity
                              ? _mass!
                              : const AlwaysStoppedAnimation(0),
                          center: _center,
                          color: AppGridTheme.lines(context),
                          background: background),
                    ),
                  ),
                ),
              ),
            ),
            widget.child ?? widget.builder!(_amountKey),
          ]),
        );
      }),
    );
  }
}
