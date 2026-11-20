import 'dart:async';

import 'package:budgets/core/ui/app_loader.dart';
import 'package:budgets/core/ui/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pull shows the Lottie loader and calls onRefresh',
      (tester) async {
    final pending = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AppRefreshIndicator(
          onRefresh: () {
            calls++;
            return pending.future;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [SizedBox(height: 2000, child: Text('content'))],
          ),
        ),
      ),
    ));
    expect(find.byType(AppLoader), findsNothing);

    final gesture = await tester.startGesture(
        tester.getTopLeft(find.text('content')) + const Offset(10, 10));
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(calls, 1);
    expect(find.byType(AppLoader), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    pending.complete();
    await tester.pumpAndSettle();
    expect(find.byType(AppLoader), findsNothing);
  });
}
