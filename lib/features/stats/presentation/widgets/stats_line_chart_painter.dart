import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatsLineChartPainter extends CustomPainter {
  const StatsLineChartPainter({
    required this.values,
    required this.progress,
    required this.color,
  });

  final List<int> values;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.isEmpty) return;
    final maximum =
        values.fold<int>(0, (result, value) => value > result ? value : result);
    final baseline = size.height - 4;
    final usableHeight = size.height - 12;
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
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: .16 * progress),
            color.withValues(alpha: 0),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 3
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
      final midpoint = (previous.dx + current.dx) / 2;
      path.cubicTo(
        midpoint,
        previous.dy,
        midpoint,
        current.dy,
        current.dx,
        current.dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(StatsLineChartPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      !listEquals(values, oldDelegate.values);
}
