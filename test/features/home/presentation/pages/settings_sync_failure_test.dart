import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/domain/models/sync_status.dart';
import 'package:budgets/features/offline/domain/providers/offline_providers.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../offline/support/offline_fixture.dart';
import '../../support/home_test_window.dart';
import '../../support/settings_sync_test_account.dart';

void main() {
  testWidgets('only Settings shows sync failures and offers recovery',
      (tester) async {
    usePhoneWindow(tester);
    final fixture = OfflineFixture();
    final connectivity = OfflineConnectivity();
    final account = SettingsSyncTestAccount(fixture, connectivity);
    addTearDown(() async {
      await account.close();
      connectivity.dispose();
    });
    account.present(SyncStatus.syncing, pendingChanges: 2);
    await tester.pumpWidget(ProviderScope(
      overrides: [offlineAccountProvider.overrideWithValue(account)],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatHomePage(today: DateTime(2026, 11, 5)),
      ),
    ));
    final l10n = AppLocalizations.of(tester.element(find.byType(ChatHomePage)));
    final retry = find.text(l10n.offlineRetry);
    final failure = find.text(l10n.offlineSetupUnavailable);
    expect(find.text(l10n.syncingStatus), findsNothing);
    await tester.tap(find.byKey(const Key('home-navigation-4')));
    await tester.pumpAndSettle();
    expect(retry, findsNothing);
    expect(find.text(l10n.syncingStatus), findsNothing);
    expect(find.text(l10n.pendingStatus(2)), findsNothing);

    account.present(SyncStatus.offline);
    await tester.pump();
    expect(find.text(l10n.offlineStatus), findsNothing);

    account.present(SyncStatus.blocked);
    await tester.pump();
    expect(failure, findsOneWidget);
    expect(tester.getTopLeft(failure).dy,
        greaterThan(tester.getBottomLeft(find.text(l10n.settings)).dy));
    expect(tester.getBottomLeft(failure).dy,
        lessThan(tester.getTopLeft(find.text(l10n.editProfile)).dy));
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(account.retries, 1);
    expect(failure, findsNothing);

    account.present(SyncStatus.conflict, pendingChanges: 2);
    await tester.pump();
    expect(find.text(l10n.offlineReview), findsOneWidget);
    expect(retry, findsNothing);
    await tester.tap(find.byKey(const Key('home-navigation-0')));
    await tester.pumpAndSettle();
    expect(find.text(l10n.syncConflictTitle), findsNothing);
    expect(find.text(l10n.offlineReview), findsNothing);
  });
}
