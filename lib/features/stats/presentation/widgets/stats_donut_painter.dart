import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatsDonutPainter extends CustomPainter {
  const StatsDonutPainter(
      {required this.amounts,
      required this.progress,
      required this.track,
      required this.colors});
  final List<int> amounts;
  final double progress;
  final Color track;
  final List<Color> colors;
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2;
    final inner = outer - 24;
    final total = amounts.fold<int>(0, (a, b) => a + b);
    if (total <= 0) {
      canvas.drawCircle(
          center,
          outer - 12,
          Paint()
            ..color = track
            ..style = PaintingStyle.stroke
            ..strokeWidth = 24);
      return;
    }
    var start = -math.pi / 2;
    for (var index = 0; index < amounts.length; index++) {
      final sweep = amounts[index] / total * math.pi * 2 * progress;
      final gap = math.min(.035, sweep / 4);
      if (sweep > 0) {
        canvas.drawPath(
            _segment(center, outer, inner, start + gap / 2, sweep - gap),
            Paint()..color = colors[index]);
      }
      start += sweep;
    }
  }

  Path _segment(
      Offset center, double outer, double inner, double start, double sweep) {
    final end = start + sweep;
    final corner = math.min(4.0, sweep * inner / 3);
    Offset point(double radius, double angle) =>
        center + Offset(math.cos(angle), math.sin(angle)) * radius;
    final path = Path()
      ..moveTo(point(outer, start + corner / outer).dx,
          point(outer, start + corner / outer).dy)
      ..arcTo(
          Rect.fromCircle(center: center, radius: outer),
          start + corner / outer,
          math.max(0.0, sweep - 2 * corner / outer),
          false);
    final a = point(outer, end), b = point(outer - corner, end);
    path.quadraticBezierTo(a.dx, a.dy, b.dx, b.dy);
    final c = point(inner + corner, end),
        d = point(inner, end),
        e = point(inner, end - corner / inner);
    path.lineTo(c.dx, c.dy);
    path.quadraticBezierTo(d.dx, d.dy, e.dx, e.dy);
    path.arcTo(
        Rect.fromCircle(center: center, radius: inner),
        end - corner / inner,
        -math.max(0.0, sweep - 2 * corner / inner),
        false);
    final f = point(inner, start), g = point(inner + corner, start);
    path.quadraticBezierTo(f.dx, f.dy, g.dx, g.dy);
    final h = point(outer - corner, start),
        i = point(outer, start),
        j = point(outer, start + corner / outer);
    path.lineTo(h.dx, h.dy);
    path.quadraticBezierTo(i.dx, i.dy, j.dx, j.dy);
    return path..close();
  }

  @override
  bool shouldRepaint(StatsDonutPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      track != oldDelegate.track ||
      !listEquals(colors, oldDelegate.colors) ||
      !listEquals(amounts, oldDelegate.amounts);
}
