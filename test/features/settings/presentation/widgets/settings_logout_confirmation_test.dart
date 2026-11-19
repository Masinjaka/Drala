import 'package:budgets/features/settings/presentation/widgets/logout_page_background.dart';
import 'dart:async';
import 'package:budgets/features/settings/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_account_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import '../../support/recording_logout_controller.dart';

void main() {
  testWidgets('logout requires confirmation and Cancel keeps the session',
      (tester) async {
    final auth = RecordingLogoutController();
    final router = GoRouter(initialLocation: '/settings', routes: [
      GoRoute(
          path: '/settings',
          builder: (_, __) => const LogoutPageBackground(
              child: Scaffold(
                  body:
                      SingleChildScrollView(child: SettingsAccountActions())))),
      GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('Guest home'))),
    ]);
    addTearDown(router.dispose);
    await tester.pumpWidget(ProviderScope(
        overrides: [authControllerProvider.overrideWith(() => auth)],
        child: MaterialApp.router(routerConfig: router)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-logout-button')));
    await tester.pumpAndSettle();
    expect(auth.calls, 0);
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('cancel-logout')));
    await tester.pumpAndSettle();
    expect(auth.calls, 0);
    expect(find.text('Guest home'), findsNothing);
    await tester.tap(find.byKey(const Key('settings-logout-button')));
    await tester.pumpAndSettle();
    auth.pending = Completer<void>();
    await tester.tap(find.byKey(const Key('confirm-logout')));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(LogoutConfirmationDialog), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(LogoutConfirmationDialog),
            matching: find.byType(CircularProgressIndicator)),
        findsOneWidget);
    expect(find.text('Guest home'), findsNothing);
    expect(
        tester
            .widget<SnapshotWidget>(find.byType(SnapshotWidget))
            .controller
            .allowSnapshotting,
        isTrue);
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(LogoutConfirmationDialog), findsOneWidget);
    auth.pending!.complete();
    await tester.pumpAndSettle();
    expect(auth.calls, 1);
    expect(find.text('Guest home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
