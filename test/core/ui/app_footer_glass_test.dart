import 'package:budgets/core/layout/app_scroll_padding.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_bottom_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('short content leaves the fixed action backdrop clear',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        extendBody: true,
        bottomNavigationBar: AppBottomAction(label: 'Action', onPressed: () {}),
        body: Builder(
            builder: (context) => ListView(
                  padding: EdgeInsets.only(
                      bottom: AppScrollPadding.trailing(context, 24)),
                  children: const [
                    SizedBox(height: 100, child: Text('Short content'))
                  ],
                )),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
