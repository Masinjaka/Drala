import 'package:budgets/core/theme.dart';
import 'package:budgets/widgets/permission_request_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('permission dialog uses dark theme text and surfaces',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: PermissionRequestDialog(
          title: 'Permission',
          message: 'Allow access?',
          onAllow: () {},
          onDeny: () {},
        ),
      ),
    ));

    final theme = AppTheme.darkTheme;
    expect(tester.widget<Dialog>(find.byType(Dialog)).backgroundColor,
        theme.colorScheme.surfaceContainerLowest);
    expect(tester.widget<Text>(find.text('Permission')).style?.color,
        theme.colorScheme.onSurface);
    expect(tester.widget<Text>(find.text('Allow access?')).style?.color,
        theme.colorScheme.onSurface);
  });
}
