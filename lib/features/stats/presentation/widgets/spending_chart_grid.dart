import 'package:flutter/material.dart';

class SpendingChartGrid extends CustomPainter {
  const SpendingChartGrid(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var row = 0; row < 4; row++) {
      final y = size.height * row / 3;
      for (double x = 0; x < size.width; x += 12) {
        canvas.drawLine(
            Offset(x, y), Offset((x + 6).clamp(0, size.width), y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(SpendingChartGrid oldDelegate) =>
      color != oldDelegate.color;
}
