import 'dart:ui' show Tristate;
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_currency_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('currency card retains selection and fits large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var tapped = false;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      builder: (context, child) => MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.5)),
        child: child!,
      ),
      home: Scaffold(
        body: SettingsCurrencyChoice(
          code: 'ANG',
          title: 'Netherlands Antillean Guilder',
          symbol: 'ƒ',
          selected: true,
          loading: false,
          first: true,
          last: true,
          onTap: () => tapped = true,
        ),
      ),
    ));
    expect(
        tester
            .getSemantics(find.byType(SettingsCurrencyChoice))
            .getSemanticsData()
            .flagsCollection
            .isSelected,
        Tristate.isTrue);
    expect(find.text('ANG'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Netherlands Antillean Guilder'));
    expect(tapped, isTrue);
    semantics.dispose();
  });
}
