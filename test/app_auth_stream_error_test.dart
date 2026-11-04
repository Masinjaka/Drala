import 'dart:convert';
import 'package:budgets/app.dart';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/onboarding/presentation/pages/getting_started_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets(
      'app and router handle failed refreshes without losing the session',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final client = (await tester.runAsync(() async => SupabaseClient(
          'https://example.supabase.co',
          'test-key',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        )))!;
    final expiry =
        DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
            1000;
    final payload = base64Url
        .encode(utf8.encode(jsonEncode({'exp': expiry})))
        .replaceAll('=', '');
    final session = {
      'access_token': 'e30.$payload.signature',
      'refresh_token': 'saved-refresh-token',
      'token_type': 'bearer',
      'expires_in': 3600,
      'expires_at': expiry,
      'user': {
        'id': 'offline-user',
        'aud': 'authenticated',
        'app_metadata': {},
        'user_metadata': {},
        'created_at': '2026-10-01T00:00:00Z'
      },
    };
    await client.auth.recoverSession(jsonEncode(session));
    addTearDown(() => tester.runAsync(client.dispose));
    final navigation = AppNavigation(
        isSignedIn: () => false, authChanges: client.auth.onAuthStateChange);
    await tester.pumpWidget(ProviderScope(
        child: MyApp(navigation: navigation, authClient: client)));
    await tester.pumpAndSettle();
    expect(find.byType(GettingStartedPage), findsOneWidget);

    // Inject the same SDK stream error produced by an offline token refresh.
    // ignore: invalid_use_of_internal_member
    client.auth.notifyException(
        AuthRetryableFetchException(message: 'Failed host lookup'),
        StackTrace.current);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(client.auth.currentSession?.refreshToken, 'saved-refresh-token');
    expect(find.byType(GettingStartedPage), findsOneWidget);

    await client.auth.recoverSession(jsonEncode(session));
    await tester.pumpAndSettle();
    expect(client.auth.currentSession?.refreshToken, 'saved-refresh-token');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
