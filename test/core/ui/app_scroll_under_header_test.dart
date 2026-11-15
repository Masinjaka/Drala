import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_bottom_action.dart';
import 'package:budgets/core/ui/app_scroll_under_header.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/ui/app_glass_backdrop.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'content scrolls behind fixed glass chrome in ${theme.brightness}',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Scaffold(
            extendBody: true,
            bottomNavigationBar:
                AppBottomAction(label: 'Action', onPressed: () {}),
            body: AppScrollUnderHeader(
              header: const SizedBox(key: Key('header'), height: 100),
              child: Builder(
                  builder: (context) => ListView(
                        padding: EdgeInsets.only(
                            bottom: AppScrollPadding.trailing(context, 16)),
                        children: [
                          for (var i = 0; i < 30; i++)
                            SizedBox(
                                key: Key('row-$i'),
                                height: 50,
                                child: Text('Row $i'))
                        ],
                      )),
            ),
          )));
      await tester.pumpAndSettle();
      final header = tester.getRect(find.byKey(const Key('header')));
      expect(
          tester.getTopLeft(find.byKey(const Key('row-0'))).dy, header.bottom);
      final scroll = tester
          .widget<NestedScrollView>(find.byType(NestedScrollView))
          .controller!;
      scroll.jumpTo(20);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 75));
      final headerOpacity = tester
          .widgetList<AppGlassBackdrop>(find.byType(AppGlassBackdrop))
          .first
          .amount;
      expect(headerOpacity, allOf(greaterThan(0), lessThan(1)));
      expect(tester.getRect(find.byKey(const Key('header'))), header);
      scroll.jumpTo(0);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(const Key('header'))), header);
      expect(tester.getRect(find.byKey(const Key('row-2'))).overlaps(header),
          isTrue);
      expect(find.byType(BackdropFilter), findsNothing);
      await tester.drag(find.byType(ListView), const Offset(0, -1800));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(const Key('row-29'))).bottom,
          lessThanOrEqualTo(tester.getTopLeft(find.text('Action')).dy));
      expect(tester.takeException(), isNull);
    });
  }
}
