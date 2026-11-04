import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'five destinations show only the selected label and animate switching',
      (tester) async {
    var selectedIndex = 0;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
        builder: (context, setState) => HomeBottomNavigationBar(
            selectedIndex: selectedIndex,
            onSelected: (index) => setState(() => selectedIndex = index)),
      )),
    ));
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Activities'), findsNothing);
    for (var index = 0; index < 5; index++) {
      expect(find.byKey(ValueKey('home-navigation-$index')), findsOneWidget);
    }
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pump();
    expect(selectedIndex, 1);
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Activities'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
