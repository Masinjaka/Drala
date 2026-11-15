import 'package:budgets/core/ui/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/activities_fixture.dart';

void main() {
  testWidgets('a shared toast follows the navigation height into Activities',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    addTearDown(tester.view.reset);
    final fixture = ActivitiesFixture();
    addTearDown(fixture.dispose);
    await fixture.load();
    await tester.pumpWidget(fixture.app());
    await tester.pumpAndSettle();

    final nav = find.byKey(const Key('home-navigation-surface'));
    final toast = find.byKey(const Key('app-toast'));
    final restingTop = tester.getTopLeft(nav).dy;
    showInfoToast(tester.element(nav), 'Notice');
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    final restingGap =
        tester.getTopLeft(nav).dy - tester.getBottomLeft(toast).dy;
    expect(restingGap, greaterThanOrEqualTo(12));

    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-input-container')), findsOneWidget);
    expect(tester.getTopLeft(nav).dy, lessThan(restingTop));
    expect(tester.getTopLeft(nav).dy - tester.getBottomLeft(toast).dy,
        closeTo(restingGap, .01));

    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(toast).dy,
        lessThanOrEqualTo(tester.getTopLeft(nav).dy - 12));
    expect(tester.getBottomLeft(toast).dy, lessThanOrEqualTo(917 - 320 - 12));

    await tester.tap(find.byKey(const Key('app-toast-close')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
    expect(toast, findsNothing);
  });
}
