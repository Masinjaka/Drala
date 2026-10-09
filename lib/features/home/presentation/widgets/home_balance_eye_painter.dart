import 'package:flutter/material.dart';
import 'package:budgets/core/theme.dart';

class HomeBalanceEyePainter extends CustomPainter {
  const HomeBalanceEyePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.homeBannerText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final center = Offset(size.width / 2, size.height / 2);
    final eye = Path()
      ..moveTo(1, center.dy)
      ..cubicTo(3.7, 3.3, 7.2, 1, center.dx, 1)
      ..cubicTo(
          size.width - 7.2, 1, size.width - 3.7, 3.3, size.width - 1, center.dy)
      ..cubicTo(size.width - 3.7, size.height - 3.3, size.width - 7.2,
          size.height - 1, center.dx, size.height - 1)
      ..cubicTo(7.2, size.height - 1, 3.7, size.height - 3.3, 1, center.dy)
      ..close();

    canvas
      ..drawPath(eye, paint)
      ..drawCircle(center, 4, paint);
  }

  @override
  bool shouldRepaint(HomeBalanceEyePainter oldDelegate) => false;
}
