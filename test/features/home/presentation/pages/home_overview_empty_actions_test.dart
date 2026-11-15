import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:budgets/core/widgets/empty_state_inline_message.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_empty_state.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:budgets/core/widgets/empty_state_illustration.dart';
import 'package:budgets/features/envelopes/presentation/widgets/add_envelope_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/empty_home_fixture.dart';

void main() {
  testWidgets(
      'Home offers compact matching illustrations and opens the envelope creation form',
      (tester) async {
    _phone(tester);
    await tester.pumpWidget(emptyHomeFixture());
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HomeOverviewEmptyState).first);
    expect(find.text(context.l10n.seeMore), findsNothing);
    expect(find.byType(EmptyStateAction), findsNothing);
    final images = tester.widgetList<EmptyStateIllustration>(
        find.byType(EmptyStateIllustration));
    expect(images.map((image) => image.asset), [
      'assets/illustrations/empty_states/envelopes.png',
      'assets/illustrations/empty_states/activities.png',
    ]);
    expect(
        images.every((image) =>
            image.width == AppEmptyStateTheme.compactIllustrationWidth),
        isTrue);
    await tester.ensureVisible(find.byKey(const Key('home-create-envelope')));
    await tester.tapOnText(
        find.textRange.ofSubstring(context.l10n.homeEmptyEnvelopeAction));
    await tester.pumpAndSettle();
    expect(find.byType(AddEnvelopeSheet), findsOneWidget);
    expect(find.byKey(const Key('envelope-funding-wallet')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('The inline transaction link opens Activities', (tester) async {
    _phone(tester);
    await tester.pumpWidget(emptyHomeFixture());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('home-track-budget')));
    final context = tester.element(find.byKey(const Key('home-track-budget')));
    await tester.tapOnText(
        find.textRange.ofSubstring(context.l10n.homeEmptyTransactionAction));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('transaction-scroll-view')), findsOneWidget);
    expect(find.byKey(const Key('guest-manual-entry-fab')), findsOneWidget);
    final action = find.byType(EmptyStateInlineMessage);
    await tester.ensureVisible(action);
    await tester.tapOnText(find.textRange
        .ofSubstring(tester.element(action).l10n.trackYourBudget));
    await tester.pumpAndSettle();
    expect(find.byType(ManualEntrySheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets('empty Home fits a small phone with large text dark=$dark',
        (tester) async {
      _phone(tester, width: 320, height: 640);
      await tester.pumpWidget(emptyHomeFixture(dark: dark, scale: 1.6));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('home-track-budget')));
      expect(find.byKey(const Key('home-track-budget')).hitTestable(),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

void _phone(WidgetTester tester, {double width = 412, double height = 917}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);
}
