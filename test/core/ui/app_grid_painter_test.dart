import 'package:budgets/core/ui/app_grid_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('gravity grows with balance magnitude and stays bounded', () {
    final strengths = [0, 10, 1000, 1000000, 1000000000]
        .map(AppGridPainter.strengthFor)
        .toList();
    expect(strengths.first, 0);
    for (var index = 1; index < strengths.length; index++) {
      expect(strengths[index], greaterThan(strengths[index - 1]));
      expect(strengths[index], inInclusiveRange(0, 1));
    }
    expect(AppGridPainter.strengthFor(-1000), strengths[2]);
    expect(AppGridPainter.strengthFor(double.nan), 0);
    expect(AppGridPainter.strengthFor(double.infinity), 0);
  });

  test('larger mass deepens the well and attracts nearby grid lines', () {
    final center = ValueNotifier(const Offset(200, 180));
    addTearDown(center.dispose);
    AppGridPainter painter(double mass) => AppGridPainter(
        mass: AlwaysStoppedAnimation(mass),
        center: center,
        color: Colors.white,
        background: Colors.black);
    const size = Size(400, 450);
    final light = painter(.2);
    final heavy = painter(.9);
    expect(heavy.pointAt(center.value, size).dy,
        greaterThan(light.pointAt(center.value, size).dy));
    const nearby = Offset(300, 180);
    expect(heavy.pointAt(nearby, size).dx,
        lessThan(light.pointAt(nearby, size).dx));
    const distant = Offset(1000, 180);
    expect(
        (heavy.pointAt(distant, size) - light.pointAt(distant, size)).distance,
        lessThan(.01));
  });
}
