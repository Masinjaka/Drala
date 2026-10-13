import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('animates to a larger filled icon without a ripple',
      (tester) async {
    var selectedIndex = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) => HomeBottomNavigationBar(
              selectedIndex: selectedIndex,
              onSelected: (index) => setState(() => selectedIndex = index),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(InkWell), findsNothing);
    expect(
      find.byKey(const ValueKey('home-navigation-icon-0-true')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<AnimatedScale>(
            find.byKey(const ValueKey('home-navigation-icon-0')),
          )
          .scale,
      1.18,
    );

    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('home-navigation-icon-1-true')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<AnimatedScale>(
            find.byKey(const ValueKey('home-navigation-icon-1')),
          )
          .scale,
      1.18,
    );
    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();
  });
}
