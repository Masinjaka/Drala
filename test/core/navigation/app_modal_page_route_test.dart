import 'package:budgets/core/navigation/app_modal_page_route.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('secondary page rises full-screen and Close dismisses downward',
      (tester) async {
    late AppModalPageRoute<void> route;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Builder(
      builder: (context) => TextButton(
          onPressed: () {
            route = AppModalPageRoute<void>(
              settings: const RouteSettings(name: '/preferences'),
              builder: (_) => const SettingsPageShell(
                  key: Key('destination'),
                  title: 'Preferences',
                  child: SizedBox()),
            );
            Navigator.of(context).push(route);
          },
          child: const Text('Open')),
    ))));
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    final destination = find.byKey(const Key('destination'));
    final halfway = tester.getTopLeft(destination);
    expect(halfway.dx, 0);
    expect(halfway.dy, greaterThan(0));
    expect(halfway.dy, lessThan(tester.view.physicalSize.height));
    expect(route.settings.name, '/preferences');
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(destination), Offset.zero);
    expect(tester.getSize(destination),
        tester.view.physicalSize / tester.view.devicePixelRatio);
    await tester.tap(find.byKey(const Key('detail-page-close')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(tester.getTopLeft(destination).dy, greaterThan(0));
    await tester.pumpAndSettle();
    expect(destination, findsNothing);
    expect(find.text('Open'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
