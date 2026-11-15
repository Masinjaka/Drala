import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_envelope_skeleton.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_transaction_skeleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final reducedMotion in [false, true]) {
    testWidgets('Home shimmer paints moving highlights, reduced=$reducedMotion',
        (tester) async {
      const envelope = Key('envelope-frame');
      const transaction = Key('transaction-frame');
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reducedMotion),
          child: const Scaffold(
            body: SizedBox(
              width: 260,
              child: Column(children: [
                RepaintBoundary(
                  key: envelope,
                  child: HomeOverviewEnvelopeSkeleton(),
                ),
                RepaintBoundary(
                  key: transaction,
                  child: HomeOverviewTransactionSkeleton(
                      isFirst: true, isLast: true),
                ),
              ]),
            ),
          ),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 180));
      final before = [
        await _pixels(tester, envelope),
        await _pixels(tester, transaction),
      ];
      await tester.pump(const Duration(milliseconds: 350));
      expect(listEquals(before[0], await _pixels(tester, envelope)),
          reducedMotion);
      expect(listEquals(before[1], await _pixels(tester, transaction)),
          reducedMotion);
    });
  }
}

Future<Uint8List> _pixels(WidgetTester tester, Key key) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  return (await tester.runAsync(() async {
    final image = await boundary.toImage();
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      return data!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }))!;
}
