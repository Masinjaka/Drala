import 'dart:convert';

import 'package:budgets/app.dart';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Restarts the app with a signed-in session whose account metadata
/// holds [cloudTheme], and returns the theme mode the app settles on.
Future<ThemeMode?> _launch(WidgetTester tester, String cloudTheme) async {
  final client = (await tester.runAsync(() async => SupabaseClient(
        'https://example.supabase.co',
        'test-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      )))!;
  addTearDown(() => tester.runAsync(client.dispose));
  final expiry =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000;
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': expiry})))
      .replaceAll('=', '');
  await client.auth.recoverSession(jsonEncode({
    'access_token': 'e30.$payload.signature',
    'refresh_token': 'refresh',
    'token_type': 'bearer',
    'expires_in': 3600,
    'expires_at': expiry,
    'user': {
      'id': 'user-1',
      'aud': 'authenticated',
      'app_metadata': {},
      'user_metadata': {'theme_mode': cloudTheme},
      'created_at': '2026-10-01T00:00:00Z',
    },
  }));
  final navigation = AppNavigation(
      isSignedIn: () => false, authChanges: const Stream<Object?>.empty());
  await tester.pumpWidget(ProviderScope(
      child: MyApp(navigation: navigation, authClient: client)));
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
  }
  final mode = tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode;
  await tester.pumpWidget(const SizedBox.shrink());
  return mode;
}

void main() {
  testWidgets('a stale account theme does not override the device choice',
      (tester) async {
    SharedPreferences.setMockInitialValues({'selectedTheme': 'light'});
    expect(await _launch(tester, 'dark'), ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('selectedTheme'), 'light');
  });

  testWidgets('the account theme seeds a device with no saved choice',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    expect(await _launch(tester, 'dark'), ThemeMode.dark);
  });
}
