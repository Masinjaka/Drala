import 'dart:typed_data';

import 'package:budgets/core/theme.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_settings_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final value in [false, true]) {
    testWidgets('matches envelope switch appearance value=$value',
        (tester) async {
      final theme = AppTheme.lightTheme.copyWith(platform: TargetPlatform.iOS);
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Column(children: [
            SwitchListTile.adaptive(value: value, onChanged: (_) {}),
            NotificationSettingsToggle(
              title: 'Notifications',
              icon: Icons.notifications,
              value: value,
              onChanged: (_) async => true,
            ),
            SwitchListTile.adaptive(value: value, onChanged: null),
            NotificationSettingsToggle(
              title: 'Disabled',
              icon: Icons.alarm,
              value: value,
              enabled: false,
              onChanged: (_) async => true,
            ),
          ]),
        ),
      ));
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches, hasLength(4));
      expect(switches[1].value, value);
      expect(switches[3].onChanged, isNull);
      final reference = await _pixels(tester, theme, switches[0]);
      final notification = await _pixels(tester, theme, switches[1]);
      expect(notification, orderedEquals(reference));
      final disabledReference = await _pixels(tester, theme, switches[2]);
      final disabledNotification = await _pixels(tester, theme, switches[3]);
      expect(disabledNotification, orderedEquals(disabledReference));
    });
  }
}

Future<Uint8List> _pixels(
    WidgetTester tester, ThemeData theme, Switch control) async {
  const boundaryKey = Key('switch-render');
  await tester.pumpWidget(MaterialApp(
    theme: theme,
    home: Scaffold(
      body: Center(
        child: RepaintBoundary(key: boundaryKey, child: control),
      ),
    ),
  ));
  await tester.pumpAndSettle();
  final boundary =
      tester.renderObject<RenderRepaintBoundary>(find.byKey(boundaryKey));
  return (await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = await image.toByteData();
    image.dispose();
    return Uint8List.fromList(bytes!.buffer.asUint8List());
  }))!;
}
