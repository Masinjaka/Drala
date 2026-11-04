import 'dart:io';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/data/services/offline_sync_manager.dart';
import 'package:budgets/features/offline/presentation/widgets/offline_sync_feedback.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late OfflineConnectivity connectivity;
  late SupabaseClient client;
  late OfflineSyncManager manager;
  setUp(() async {
    connectivity = OfflineConnectivity();
    client = SupabaseClient('https://example.supabase.co', 'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false));
    manager = OfflineSyncManager(client, connectivity);
    await manager.start();
  });
  tearDown(() async {
    await manager.close();
    await client.dispose();
    connectivity.dispose();
  });
  testWidgets('DNS failures show one localized toast without replacing content',
      (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    final text = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigator,
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => OfflineSyncFeedback(
          manager: manager, navigatorKey: navigator, child: child!),
      home: Scaffold(body: TextField(controller: text)),
    ));
    await tester.enterText(find.byType(TextField), 'Unfinished entry');
    final field = tester.element(find.byType(TextField));
    connectivity.failed(const SocketException('Failed host lookup'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final l10n = AppLocalizations.of(tester.element(find.byType(TextField)));
    expect(find.text(l10n.offlineModeToast), findsOneWidget);
    expect(text.text, 'Unfinished entry');
    expect(tester.element(find.byType(TextField)), same(field));
    connectivity.failed(const SocketException('Failed host lookup'));
    await tester.pump();
    expect(find.text(l10n.offlineModeToast), findsOneWidget);
    connectivity.recovered();
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text(l10n.onlinePendingToast), findsOneWidget);
    expect(text.text, 'Unfinished entry');
    expect(tester.element(find.byType(TextField)), same(field));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 6));

    text.dispose();
    expect(tester.takeException(), isNull);
  });
}
