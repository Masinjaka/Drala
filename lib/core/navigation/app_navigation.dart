import 'package:budgets/core/navigation/auth_router_refresh.dart';
import 'package:budgets/features/auth/presentation/pages/login_page.dart';
import 'package:budgets/features/auth/presentation/pages/reset_password_page.dart';
import 'package:budgets/features/auth/presentation/pages/sign_up_page.dart';
import 'package:budgets/features/onboarding/presentation/pages/account_setup_page.dart';
import 'package:budgets/features/auth/presentation/pages/verify_reset_code_page.dart';
import 'package:budgets/features/home/presentation/pages/currency_home_page.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/data/guest_cloud_sync_service.dart';
import 'package:budgets/features/guest/presentation/pages/guest_account_choice_page.dart';
import 'package:budgets/features/onboarding/presentation/pages/getting_started_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppNavigation {
  AppNavigation({
    required bool Function() isSignedIn,
    required Stream<Object?> authChanges,
    bool Function()? needsOnboarding,
    GuestSession? guestSession,
  })  : _isSignedIn = isSignedIn,
        _needsOnboarding = needsOnboarding ?? (() => false),
        _guestSession = guestSession,
        _refresh = AuthRouterRefresh(authChanges) {
    router = GoRouter(
      initialLocation: _isSignedIn()
          ? '/home'
          : guestSession?.isActive == true
              ? guestSession!.onboardingComplete
                  ? guestSession.accountChoiceSeen || _isSignedIn()
                      ? '/home'
                      : '/account-choice'
                  : '/onboarding'
              : '/getting-started',
      observers: [SentryNavigatorObserver()],
      refreshListenable: Listenable.merge([
        _refresh,
        if (guestSession != null) guestSession,
      ]),
      redirect: _redirect,
      routes: [
        GoRoute(
          path: '/getting-started',
          builder: (_, __) => const GettingStartedPage(),
        ),
        GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpPage()),
        GoRoute(
          path: '/reset-password',
          builder: (_, __) => const ResetPasswordPage(),
        ),
        GoRoute(
          path: '/verify-reset-code',
          redirect: (_, state) =>
              state.extra is String ? null : '/reset-password',
          builder: (_, state) => VerifyResetCodePage(
            email: state.extra! as String,
          ),
        ),
        GoRoute(
          path: '/upload-profile-photo',
          redirect: (_, __) => '/onboarding',
        ),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => AccountSetupPage(
            completionRoute: _guestSession?.isActive == true && !_isSignedIn()
                ? '/account-choice'
                : '/home',
            onCompleted: _guestSession?.isActive == true
                ? () async {
                    _guestSession!.markOnboardingComplete();
                    if (_isSignedIn()) {
                      await GuestCloudSyncService(
                        Supabase.instance.client,
                        _guestSession,
                      ).sync();
                    }
                  }
                : null,
          ),
        ),
        GoRoute(
          path: '/account-choice',
          builder: (_, __) => const GuestAccountChoicePage(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => CurrencyHomePage(isSignedIn: _isSignedIn),
        ),
      ],
    );
  }

  factory AppNavigation.supabase(
    SupabaseClient client, {
    GuestSession? guestSession,
  }) =>
      AppNavigation(
        isSignedIn: () => client.auth.currentSession != null,
        authChanges: client.auth.onAuthStateChange,
        guestSession: guestSession,
        needsOnboarding: () =>
            client.auth.currentUser?.userMetadata?['onboarding_required'] ==
            true,
      );

  final bool Function() _isSignedIn;
  final bool Function() _needsOnboarding;
  final GuestSession? _guestSession;
  final AuthRouterRefresh _refresh;
  late final GoRouter router;

  static const _publicPaths = {
    '/getting-started',
    '/login',
    '/signup',
    '/reset-password',
    '/verify-reset-code',
    '/account-choice',
  };

  String? _redirect(BuildContext context, GoRouterState state) {
    final isSignedIn = _isSignedIn();
    final isPublic = _publicPaths.contains(state.matchedLocation);
    if (_guestSession?.isActive == true) {
      if (isPublic) return null;
      if (!_guestSession!.onboardingComplete &&
          state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }
      if (_guestSession.onboardingComplete &&
          !_guestSession.accountChoiceSeen &&
          !isSignedIn &&
          state.matchedLocation == '/home') {
        return '/account-choice';
      }
      return null;
    }
    if (!isSignedIn && !isPublic) return '/getting-started';
    if (isSignedIn &&
        _needsOnboarding() &&
        state.matchedLocation != '/onboarding') {
      return '/onboarding';
    }
    if (isSignedIn && isPublic) return '/home';
    return null;
  }

  void dispose() {
    router.dispose();
    _refresh.dispose();
  }
}
