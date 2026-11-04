import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatsLineChartPainter extends CustomPainter {
  const StatsLineChartPainter({
    required this.values,
    required this.progress,
    required this.color,
    required this.fillGradient,
  });

  final List<int> values;
  final double progress;
  final Color color;
  final Gradient fillGradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.isEmpty) return;
    final maximum =
        values.fold<int>(0, (result, value) => value > result ? value : result);
    final baseline = size.height - 6;
    final usableHeight = size.height - 9;
    final points = List.generate(values.length, (index) {
      final x = values.length == 1
          ? size.width / 2
          : size.width * index / (values.length - 1);
      final targetY = maximum == 0
          ? baseline
          : baseline - (values[index] / maximum * usableHeight);
      return Offset(x, lerpDouble(baseline, targetY, progress)!);
    });
    final line = _smoothPath(points);
    final area = Path.from(line)
      ..lineTo(points.last.dx, baseline)
      ..lineTo(points.first.dx, baseline)
      ..close();
    canvas.drawPath(
        area,
        Paint()
          ..shader = fillGradient
              .createShader(Rect.fromLTRB(0, 0, size.width, baseline)));

    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  Path _smoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      final previous = points[index - 1];
      final current = points[index];
      final before = points[index > 1 ? index - 2 : 0];
      final after = points[index + 1 < points.length ? index + 1 : index];
      final control1 = previous + (current - before) / 6;
      final control2 = current - (after - previous) / 6;
      final low = previous.dy < current.dy ? previous.dy : current.dy;
      final high = previous.dy > current.dy ? previous.dy : current.dy;
      path.cubicTo(control1.dx, control1.dy.clamp(low, high), control2.dx,
          control2.dy.clamp(low, high), current.dx, current.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(StatsLineChartPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      fillGradient != oldDelegate.fillGradient ||
      !listEquals(values, oldDelegate.values);
}
