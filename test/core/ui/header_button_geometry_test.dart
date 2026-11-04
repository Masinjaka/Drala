import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/detail_page_shell.dart';
import 'package:budgets/core/ui/outlined_square_button.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_header.dart';
import 'package:budgets/features/stats/presentation/pages/finance_stats_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../features/envelopes/support/editable_envelope_repository.dart';
import '../../features/home/support/overview_fixture.dart';
import '../../features/stats/support/reference_stats_repository.dart';

void main() {
  testWidgets('page header buttons match Envelopes size and safe-area position',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    tester.view.padding = const FakeViewPadding(top: 24);
    tester.view.viewPadding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.reset);
    final pages = <Widget>[
      EnvelopePage(
          showBackButton: false, repository: EditableEnvelopeRepository()),
      const FinanceStatsPage(
          showBackButton: false, repository: ReferenceStatsRepository()),
      const DetailPageShell(title: 'Details', child: SizedBox()),
      Scaffold(
          body: SafeArea(
              child: SettingsPageHeader(
                  title: 'Settings',
                  showBackButton: true,
                  onNotifications: () {}))),
    ];
    for (final page in pages) {
      await tester.pumpWidget(MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: page));
      await tester.pumpAndSettle();
      final calendar = find.byKey(const Key('stats-pick-month'));
      final buttons = find.byType(OutlinedSquareButton);
      if (calendar.evaluate().isNotEmpty) {
        final bounds = tester.getRect(calendar);
        expect(bounds.top, 33);
        expect(bounds.height, 46);
        expect(bounds.right, 388);
      }
      for (final element in buttons.evaluate()) {
        final button = element.widget as OutlinedSquareButton;
        final bounds = tester.getRect(find.byWidget(button));
        expect(button.visualSize, 46);
        expect(button.iconSize, 22);
        expect(bounds.size, const Size(46, 46));
        expect(bounds.top, 33);
        expect(bounds.left == 24 || bounds.right == 388, isTrue);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
    await tester.pumpWidget(overviewFixture());
    await tester.pumpAndSettle();
    final homeButton =
        tester.getRect(find.byKey(const Key('notification-inbox-button')));
    expect(homeButton, const Rect.fromLTWH(342, 33, 46, 46));
    await tester.tap(find.byKey(const ValueKey('home-navigation-1')));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(const Key('notification-inbox-button'))),
        homeButton);
    expect(tester.takeException(), isNull);
  });
}
