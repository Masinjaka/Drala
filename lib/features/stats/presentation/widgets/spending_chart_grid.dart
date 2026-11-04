import 'package:flutter/material.dart';

class SpendingChartGrid extends CustomPainter {
  const SpendingChartGrid(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = .7;
    for (var row = 0; row < 3; row++) {
      final y = 3 + (size.height - 9) * row / 2;
      for (double x = 0; x < size.width; x += 6) {
        canvas.drawLine(
            Offset(x, y), Offset((x + 3).clamp(0, size.width), y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(SpendingChartGrid oldDelegate) =>
      color != oldDelegate.color;
}
