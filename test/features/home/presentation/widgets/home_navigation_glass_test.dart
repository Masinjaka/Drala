import 'dart:ui' as ui;

import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_glass_theme.dart';
import 'package:budgets/core/ui/app_navigation_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'nav glass shows the backdrop with readable ${theme.brightness} icons',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(412, 400);
      addTearDown(tester.view.reset);
      final boundary = GlobalKey();
      Future<void> showTab(int selectedIndex) async {
        await tester.pumpWidget(MaterialApp(
          theme: theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RepaintBoundary(
            key: boundary,
            child: Scaffold(
              extendBody: true,
              body: const Row(children: [
                Expanded(
                    flex: 4,
                    child: ColoredBox(
                        color: Colors.black, child: SizedBox.expand())),
                Expanded(
                    child: ColoredBox(
                        color: Colors.white, child: SizedBox.expand())),
              ]),
              bottomNavigationBar: HomeBottomNavigationBar(
                  selectedIndex: selectedIndex, onSelected: (_) {}),
            ),
          ),
        ));
        await tester.pumpAndSettle();
      }

      await showTab(2);
      final pill = find.byKey(const Key('home-navigation-surface'));
      final context = tester.element(pill);
      final tint = AppGlassTheme.tint(context, navigation: true);
      final brightBackdrop = Color.alphaBlend(tint, Colors.white);
      final inactive = AppNavigationTheme.icon(context, selected: false);
      final selected = AppNavigationTheme.icon(context, selected: true);
      expect(tint.a, lessThan(.72));
      expect(_contrast(inactive, brightBackdrop), greaterThanOrEqualTo(3));
      expect(
          _contrast(selected, AppNavigationTheme.selectedBackground(context)),
          greaterThanOrEqualTo(4.5));

      Future<int> backdropDifference() async {
        final y = tester.getTopLeft(pill).dy.round() + 9;
        return (await tester.runAsync(() async {
          final render = boundary.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
          final image = await render.toImage();
          final bytes =
              (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
          image.dispose();
          return bytes.getUint8((y * 412 + 370) * 4) -
              bytes.getUint8((y * 412 + 300) * 4);
        }))!;
      }

      final otherTabDifference = await backdropDifference();
      expect(otherTabDifference, greaterThan(3));
      await showTab(0);
      expect(await backdropDifference(), greaterThan(otherTabDifference));
      expect(find.descendant(of: pill, matching: find.byType(BackdropFilter)),
          findsOneWidget);
    });
  }
}

double _contrast(Color foreground, Color background) =>
    (foreground.computeLuminance() + .05) /
    (background.computeLuminance() + .05);
