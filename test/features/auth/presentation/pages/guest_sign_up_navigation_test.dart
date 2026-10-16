import 'package:budgets/core/legal/legal_document_launcher.dart';
import 'package:budgets/features/auth/domain/interfaces/auth_repository.dart';
import 'package:budgets/features/auth/domain/providers/auth_providers.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final hasSession in [true, false]) {
    testWidgets(
      'completed guest signup goes home with session=$hasSession',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(412, 917);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final database = GuestDatabase(NativeDatabase.memory());
        addTearDown(database.close);
        final guest = await GuestSession.load(database);
        await guest.start();
        await guest.onboarding.complete(
          currency: 'MGA',
          language: 'en',
          categories: const [],
          wallets: const [],
        );
        guest.markOnboardingComplete();
        final router = GoRouter(
          initialLocation: '/signup',
          routes: [
            GoRoute(
              path: '/signup',
              builder: (_, __) => const SignUpPage(
                legalLauncher: _NoopLegalDocumentLauncher(),
              ),
            ),
            for (final path in ['/home', '/login', '/onboarding'])
              GoRoute(
                path: path,
                builder: (_, __) => Scaffold(body: Text(path)),
              ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(ProviderScope(
          overrides: [
            guestSessionProvider.overrideWithValue(guest),
            authRepositoryProvider.overrideWithValue(
              _SessionAuthRepository(hasSession),
            ),
            authControllerProvider.overrideWith(
              () => _FakeAuthController(guest, hasSession),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ));

        await tester.enterText(find.byType(TextFormField).at(0), 'Guest');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'guest@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'Abcdef1!');
        await tester.pump(const Duration(milliseconds: 400));
        final confirmation = find.byKey(const Key('confirm-password-field'));
        await tester.ensureVisible(confirmation);
        await tester.enterText(
          find.descendant(
            of: confirmation,
            matching: find.byType(TextFormField),
          ),
          'Abcdef1!',
        );
        final consent = find.byKey(const Key('legal-consent-checkbox'));
        await tester.ensureVisible(consent);
        await tester.tap(consent);
        await tester.pump();
        await tester.tap(find.byKey(const Key('sign-up-submit')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('/home'), findsOneWidget);
        expect(find.text('/onboarding'), findsNothing);
        if (hasSession) {
          expect(guest.isActive, false);
        } else {
          expect(guest.isActive, true);
          expect(guest.accountChoiceSeen, true);
        }
      },
    );
  }
}

class _FakeAuthController extends AuthController {
  _FakeAuthController(this.guest, this.hasSession);

  final GuestSession guest;
  final bool hasSession;

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    if (hasSession) await guest.stopAfterSync();
  }
}

class _SessionAuthRepository implements AuthRepository {
  const _SessionAuthRepository(this.session);

  final bool session;

  @override
  Future<bool> hasSession() async => session;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopLegalDocumentLauncher implements LegalDocumentLauncher {
  const _NoopLegalDocumentLauncher();

  @override
  Future<void> openPrivacyPolicy() async {}

  @override
  Future<void> openTermsAndConditions() async {}
}
