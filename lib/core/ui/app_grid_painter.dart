import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A sampled mesh attracted toward the balance, with a projected gravity well.
class AppGridPainter extends CustomPainter {
  AppGridPainter({
    required this.mass,
    required this.center,
    required this.color,
    required this.background,
  }) : super(repaint: Listenable.merge([mass, center]));

  final Animation<double> mass;
  final ValueListenable<Offset> center;
  final Color color;
  final Color background;

  // Logarithmic scaling keeps small balances expressive and large ones bounded.
  static double strengthFor(num amount) {
    if (!amount.isFinite) return 0;
    return (math.log(1 + amount.abs()) / math.log(100000001)).clamp(0, 1);
  }

  Offset pointAt(Offset point, Size size) {
    final delta = point - center.value;
    final radius = math.min(size.width * .55, 260.0);
    final distance = delta.dx * delta.dx + delta.dy * delta.dy * 1.6;
    final influence = math.exp(-distance / (radius * radius));
    final pull = mass.value * influence;
    final ripple = math.sin(point.dy / 43 + point.dx / 71) * 1.2;
    return Offset(
      point.dx - delta.dx * pull * .38 + ripple,
      point.dy - delta.dy * pull * .22 + radius * .42 * pull + ripple,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final focus = center.value;
    final radius = math.min(size.width * .9, 500.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8
      ..shader = RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
              stops: const [.12, 1])
          .createShader(Rect.fromCircle(center: focus, radius: radius));
    const spacing = 44.0;
    const step = 6.0;
    final bottom = size.height;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    void line(bool vertical, double fixed) {
      final path = Path();
      final limit = vertical ? bottom + 100 : size.width + 80;
      var first = true;
      for (double sample = -100; sample <= limit; sample += step) {
        final point = pointAt(
            vertical ? Offset(fixed, sample) : Offset(sample, fixed), size);
        if (first) {
          path.moveTo(point.dx, point.dy);
          first = false;
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, paint);
    }

    for (double x = -88; x <= size.width + 88; x += spacing) {
      line(true, x);
    }
    for (double y = -88; y <= bottom + 44; y += spacing) {
      line(false, y);
    }
    canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [background.withValues(alpha: 0), background],
              stops: const [.55, 1]).createShader(Offset.zero & size));
    canvas.restore();
  }

  @override
  bool shouldRepaint(AppGridPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.background != background ||
      oldDelegate.mass != mass ||
      oldDelegate.center != center;
}
