import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_grid_background.dart';
import 'package:budgets/core/ui/app_grid_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('neutral pages ignore amounts and allocate no running animation',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: AppGridBackground(
                amount: 10000000, child: Center(child: Text('Settings'))))));
    await tester.pumpAndSettle();
    final grid = tester
        .widget<CustomPaint>(find.byKey(const Key('app-page-grid')))
        .painter! as AppGridPainter;
    expect(grid.mass.value, 0);
    expect(grid.center.value.dx, 400);
    expect(tester.hasRunningAnimations, isFalse);
    expect(find.text('Settings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'well follows the amount while scrolling and settles after changes',
      (tester) async {
    var amount = 100.0;
    late StateSetter update;
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: StatefulBuilder(builder: (context, setState) {
          update = setState;
          return AppGridBackground(
              gravity: true,
              amount: amount,
              loading: false,
              builder: (key) => SingleChildScrollView(
                      child: Column(children: [
                    const SizedBox(height: 150),
                    SizedBox(
                        key: key, height: 50, child: const Text('Balance')),
                    const SizedBox(height: 1200),
                  ])));
        }))));
    await tester.pumpAndSettle();
    AppGridPainter grid() => tester
        .widget<CustomPaint>(find.byKey(const Key('app-page-grid')))
        .painter! as AppGridPainter;
    final initialStrength = grid().mass.value;
    expect(grid().center.value.dy, 175);
    update(() => amount = 1000000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(grid().mass.value, greaterThan(initialStrength));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
    expect(
        grid().mass.value, closeTo(AppGridPainter.strengthFor(amount), .0001));
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(grid().center.value.dy, lessThan(175));
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'reduced motion is immediate and hidden balances have neutral mass',
      (tester) async {
    final visibility = AmountVisibilityController();
    addTearDown(visibility.dispose);
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(
                size: Size(400, 800), disableAnimations: true),
            child: AmountVisibilityScope(
                controller: visibility,
                child: Scaffold(
                    body: AppGridBackground(
                        gravity: true,
                        amount: 1000000,
                        loading: false,
                        builder: (key) =>
                            Center(child: SizedBox(key: key, height: 50))))))));
    await tester.pump();
    AppGridPainter grid() => tester
        .widget<CustomPaint>(find.byKey(const Key('app-page-grid')))
        .painter! as AppGridPainter;
    expect(grid().mass.value, greaterThan(0));
    expect(tester.hasRunningAnimations, isFalse);
    visibility.toggle();
    await tester.pump();
    expect(grid().mass.value, 0);
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
