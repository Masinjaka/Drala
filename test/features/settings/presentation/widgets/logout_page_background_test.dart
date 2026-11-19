import 'dart:async';

import 'package:budgets/features/settings/presentation/widgets/logout_page_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps the painted page while logout removes its content',
      (tester) async {
    final boundaryKey = GlobalKey();
    final pending = Completer<void>();
    late BuildContext pageContext;
    late StateSetter update;
    var removed = false;
    await tester.pumpWidget(MaterialApp(
      home: RepaintBoundary(
        key: boundaryKey,
        child: StatefulBuilder(builder: (context, setState) {
          update = setState;
          return LogoutPageBackground(
            child: removed
                ? const SizedBox.shrink()
                : Builder(builder: (context) {
                    pageContext = context;
                    return const Scaffold(
                        body: Center(child: Text('Settings')));
                  }),
          );
        }),
      ),
    ));
    await tester.pumpAndSettle();
    final boundary =
        boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final logout = LogoutPageBackground.hold(pageContext, () async {
      update(() => removed = true);
      await pending.future;
    });
    await tester.pump();
    final before = await tester.runAsync(() => boundary.toImage(pixelRatio: 1));
    addTearDown(before!.dispose);
    await tester.pump();
    expect(find.text('Settings'), findsNothing);
    expect(tester.getSize(find.byType(SnapshotWidget)),
        tester.view.physicalSize / tester.view.devicePixelRatio);
    await expectLater(find.byKey(boundaryKey), matchesReferenceImage(before));
    pending.complete();
    await tester.pump();
    await tester.pump();
    await logout;
    await tester.pump();
    expect(
        tester
            .widget<SnapshotWidget>(find.byType(SnapshotWidget))
            .controller
            .allowSnapshotting,
        isFalse);
    expect(tester.takeException(), isNull);
  });
}
