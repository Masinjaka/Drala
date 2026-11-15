import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/core/ui/app_toast_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('slides up above the keyboard and can be dismissed',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    tester.view.viewInsets = const FakeViewPadding(bottom: 200);
    addTearDown(tester.view.reset);
    var dismissed = false;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Stack(children: [
          AppToastOverlay(
            message: 'Entry added.',
            type: AppToastType.success,
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
    expect(tester.getRect(toast).bottom, closeTo(388, 0.1));
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('Entry added.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('app-toast-close')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(dismissed, isTrue);
  });

  testWidgets('light mode shows dark toasts and dark mode shows light toasts',
      (tester) async {
    Future<void> show(ThemeData theme, AppToastType type,
        {String message = 'Test'}) async {
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: Stack(children: [
            AppToastOverlay(
              message: message,
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
        .decoration! as ShapeDecoration;
    expect(decoration.color,
        AppToastTheme.light.background.withValues(alpha: .84));
    expect(decoration.shape, isA<StadiumBorder>());
    expect((decoration.shape as StadiumBorder).side.style, BorderStyle.solid);
    final clip = tester.widget<ClipPath>(find
        .ancestor(
          of: find.byKey(const Key('app-toast')),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is ClipPath &&
                widget.clipper is ShapeBorderClipper &&
                (widget.clipper! as ShapeBorderClipper).shape is StadiumBorder,
          ),
        )
        .first);
    expect((clip.clipper! as ShapeBorderClipper).shape, AppToastTheme.shape);
    expect(
        find.ancestor(
            of: find.byKey(const Key('app-toast')),
            matching: find.byType(BackdropFilter)),
        findsOneWidget);
    final textStyle = tester.widget<Text>(find.text('Test')).style!;
    expect(textStyle.fontFamily, AppTheme.fontFamily);
    expect(textStyle.fontWeight, FontWeight.normal);
    expect(textStyle.fontSize, 14);
    expect(_contrast(Colors.white, decoration.color!, Colors.white),
        greaterThanOrEqualTo(4.5));
    expect(tester.widget<Text>(find.text('Test')).style?.color, Colors.white);
    expect(
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).backgroundColor,
        AppToastTheme.light.error);

    final toast = find.byKey(const Key('app-toast'));
    final singleLineHeight = tester.getSize(toast).height;
    const multiline =
        'A longer message\nthat needs to wrap\nacross three lines.';
    await show(AppTheme.darkTheme, AppToastType.info, message: multiline);
    expect(tester.getSize(toast).height, greaterThan(singleLineHeight));
    decoration = tester
        .widget<Container>(
          find.byKey(const Key('app-toast')),
        )
        .decoration! as ShapeDecoration;
    expect(decoration.shape, isA<StadiumBorder>());
    expect(
        decoration.color, AppToastTheme.dark.background.withValues(alpha: .84));
    expect(_contrast(const Color(0xFF333333), decoration.color!, Colors.black),
        greaterThanOrEqualTo(4.5));
    expect(tester.widget<Text>(find.text(multiline)).style?.color,
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
        bottomNavigationBar: const SizedBox(height: 91),
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
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.byKey(const Key('app-toast'))).bottom,
      closeTo(497, 0.1),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });
}

double _contrast(Color foreground, Color tint, Color backdrop) {
  final surface = Color.alphaBlend(tint, backdrop).computeLuminance();
  final text = foreground.computeLuminance();
  return surface > text
      ? (surface + .05) / (text + .05)
      : (text + .05) / (surface + .05);
}
