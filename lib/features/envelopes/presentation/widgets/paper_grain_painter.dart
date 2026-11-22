import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

/// Paints a fixed paper-like grain of fine light and dark specks.
///
/// Each speck comes from a hash of its grid position, so the texture never
/// shimmers between frames and a wider fill only adds grain at its edge.
/// All specks are drawn in two batched calls.
class PaperGrainPainter extends CustomPainter {
  const PaperGrainPainter({
    required this.light,
    required this.dark,
    required this.density,
  });

  final Color light;
  final Color dark;

  /// Share of grid cells that receive a speck, from 0 to 1.
  final double density;

  static const _cell = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final columns = (size.width / _cell).ceil();
    final rows = (size.height / _cell).ceil();
    final lights = <double>[];
    final darks = <double>[];
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        final hash = _hash(column, row);
        if ((hash & 0xFFFF) / 0xFFFF >= density) continue;
        // Jitter within the cell so the grain has no visible grid.
        final x = (column + ((hash >> 16) & 0xFF) / 0xFF) * _cell;
        final y = (row + ((hash >> 24) & 0xFF) / 0xFF) * _cell;
        ((hash >> 8) & 1) == 0 ? lights.addAll([x, y]) : darks.addAll([x, y]);
      }
    }
    _draw(canvas, lights, light, 1.1);
    _draw(canvas, darks, dark, 0.9);
  }

  void _draw(Canvas canvas, List<double> points, Color color, double width) {
    if (points.isEmpty) return;
    canvas.drawRawPoints(
      ui.PointMode.points,
      Float32List.fromList(points),
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Small integer hash (xorshift-multiply) with good spread for grid cells.
  static int _hash(int x, int y) {
    var h = (x * 374761393 + y * 668265263) & 0xFFFFFFFF;
    h = ((h ^ (h >> 13)) * 1274126177) & 0xFFFFFFFF;
    return (h ^ (h >> 16)) & 0xFFFFFFFF;
  }

  @override
  bool shouldRepaint(covariant PaperGrainPainter oldDelegate) =>
      oldDelegate.light != light ||
      oldDelegate.dark != dark ||
      oldDelegate.density != density;
}
