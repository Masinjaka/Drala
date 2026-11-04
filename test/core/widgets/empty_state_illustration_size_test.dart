import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_empty_state_theme.dart';
import 'package:budgets/core/widgets/empty_state_illustration.dart';
import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_empty_state.dart';
import 'package:budgets/features/home/presentation/widgets/activity_empty_state.dart';
import 'package:budgets/features/home/presentation/widgets/home_empty_state.dart';
import 'package:budgets/features/notifications/presentation/widgets/finance_notifications_empty_state.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final states = <String, Widget>{
    'Activities': const ActivityEmptyState(),
    'Home': const HomeEmptyState(isFirstEntryExperience: true),
    'Notifications': const FinanceNotificationsEmptyState(),
    'Envelopes': const EnvelopeEmptyState(),
    'Categories': const EmptyStatePhrase(
        title: 'Categories',
        illustrationAsset: 'assets/illustrations/empty_states/categories.png'),
    'Wallets': const EmptyStatePhrase(
        title: 'Wallets',
        illustrationAsset: 'assets/illustrations/empty_states/wallets.png'),
  };
  for (final entry in states.entries) {
    testWidgets('${entry.key} uses the smaller shared illustration size',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: entry.value),
      ));
      await tester.pumpAndSettle();
      final illustration = tester
          .widget<EmptyStateIllustration>(find.byType(EmptyStateIllustration));
      expect(illustration.width, AppEmptyStateTheme.illustrationWidth);
      expect(tester.getSize(find.byType(Image)).width,
          AppEmptyStateTheme.illustrationWidth);
      expect(tester.takeException(), isNull);
    });
  }
}
