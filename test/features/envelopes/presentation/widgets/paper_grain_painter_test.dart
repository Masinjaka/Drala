import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_progress.dart';
import 'package:budgets/features/envelopes/presentation/widgets/paper_grain_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _painter = PaperGrainPainter(
  light: AppEnvelopeTheme.progressGrainLight,
  dark: AppEnvelopeTheme.progressGrainDark,
  density: AppEnvelopeTheme.progressGrainDensity,
);

void main() {
  testWidgets('the filled part of the bar carries the paper grain',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: EnvelopeProgress(value: .5, foregroundColor: Colors.orange),
      ),
    ));
    final fill = find.byKey(const Key('envelope-progress-fill'));
    final grain = find.descendant(
        of: fill,
        matching: find.byWidgetPredicate((widget) =>
            widget is CustomPaint && widget.painter is PaperGrainPainter));

    expect(grain, findsOneWidget);
    expect(tester.getSize(grain), tester.getSize(fill));
    expect(
        find.descendant(of: fill, matching: find.byType(RepaintBoundary)),
        findsOneWidget,
        reason: 'grain is cached instead of repainted with the page');
  });

  test('never repaints unless its look changes', () {
    expect(_painter.shouldRepaint(_painter), isFalse);
    expect(
        _painter.shouldRepaint(const PaperGrainPainter(
            light: Colors.white, dark: Colors.black, density: .5)),
        isTrue);
  });

  testWidgets('paints the same grain every time', (tester) async {
    Future<List<int>> render() async {
      final key = GlobalKey();
      await tester.pumpWidget(Center(
        child: RepaintBoundary(
          key: key,
          child: const ColoredBox(
            color: Colors.orange,
            child: CustomPaint(size: Size(160, 20), painter: _painter),
          ),
        ),
      ));
      final boundary = key.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await tester.runAsync(() => boundary.toImage());
      final bytes = await tester.runAsync(() => image!.toByteData());
      return bytes!.buffer.asUint8List().toList();
    }

    final first = await render();
    await tester.pumpWidget(const SizedBox());
    final second = await render();
    expect(second, first);
    expect(first.toSet().length, greaterThan(4),
        reason: 'the texture actually varies across the bar');
  });
}
