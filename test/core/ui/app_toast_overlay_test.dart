import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/core/ui/app_toast_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('slides up above the navigation bar and can be dismissed',
      (tester) async {
    var dismissed = false;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Stack(children: [
          AppToastOverlay(
            message: 'Entry added.',
            type: AppToastType.success,
            aboveNavigationBar: true,
            displayDuration: const Duration(seconds: 10),
            animationDuration: const Duration(milliseconds: 100),
            onDismissed: () => dismissed = true,
            onDisposed: () {},
          ),
        ]),
      ),
    ));

    final toast = find.byKey(const Key('app-toast'));
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getRect(toast).bottom, closeTo(515, 0.1));
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('Entry added.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('app-toast-close')));
    await tester.pumpAndSettle();
    expect(dismissed, isTrue);
  });

  testWidgets('light mode shows dark toasts and dark mode shows light toasts',
      (tester) async {
    Future<void> show(ThemeData theme, AppToastType type) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Stack(children: [
            AppToastOverlay(
              message: 'Test',
              type: type,
              onDismissed: () {},
              onDisposed: () {},
            ),
          ]),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 220));
    }

    await show(AppTheme.lightTheme, AppToastType.error);
    var decoration = tester
        .widget<Container>(
          find.byKey(const Key('app-toast')),
        )
        .decoration! as BoxDecoration;
    expect(decoration.color, AppToastTheme.light.background);
    expect(decoration.color, const Color(0xFF303030));
    expect(tester.widget<Text>(find.text('Test')).style?.color, Colors.white);
    expect(
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundColor,
        AppToastTheme.light.error);

    await show(AppTheme.darkTheme, AppToastType.info);
    decoration = tester
        .widget<Container>(
          find.byKey(const Key('app-toast')),
        )
        .decoration! as BoxDecoration;
    expect(decoration.color, AppToastTheme.dark.background);
    expect(decoration.color, Colors.white);
    expect(tester.widget<Text>(find.text('Test')).style?.color,
        const Color(0xFF333333));
    expect(
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundColor,
        AppToastTheme.dark.info);
  });

  testWidgets('the shared toast helper clears a parent navigation bar',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        bottomNavigationBar: const SizedBox(height: 73),
        body: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showInfoToast(context, 'Notice'),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      tester.getRect(find.byKey(const Key('app-toast'))).bottom,
      closeTo(515, 0.1),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });
}
