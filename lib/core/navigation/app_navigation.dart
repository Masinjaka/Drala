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
import 'package:budgets/features/onboarding/presentation/pages/setup_complete_page.dart';
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
          path: '/sign-in-choice',
          builder: (_, __) =>
              const GuestAccountChoicePage(showGuestOption: false),
        ),
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
          builder: (context, __) => AccountSetupPage(
            onConfigured: _guestSession?.isActive == true && !_isSignedIn()
                ? () async {
                    await _guestSession!.prepareCompletion();
                    if (context.mounted) context.go('/account-choice');
                  }
                : null,
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
          path: '/setup-complete',
          builder: (_, __) => const SetupCompletePage(),
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
    '/sign-in-choice',
    '/reset-password',
    '/verify-reset-code',
    '/account-choice',
  };

  String? _redirect(BuildContext context, GoRouterState state) {
    // Keep the current route until the guest destination is fully initialized.
    if (_guestSession?.isSigningOut == true) return null;
    final isSignedIn = _isSignedIn();
    final isPublic = _publicPaths.contains(state.matchedLocation);
    final pending = _guestSession?.completionPending == true;
    if (state.matchedLocation == '/setup-complete') {
      return pending
          ? null
          : isSignedIn || _guestSession?.isActive == true
              ? '/home'
              : '/getting-started';
    }
    if (pending &&
        state.matchedLocation == '/home' &&
        (isSignedIn && _guestSession?.isActive == false ||
            !isSignedIn && _guestSession?.accountChoiceSeen == true)) {
      return '/setup-complete';
    }
    if (_guestSession?.isActive == true) {
      if (!isSignedIn &&
          _guestSession!.onboardingComplete &&
          _guestSession.accountChoiceSeen &&
          (state.matchedLocation == '/getting-started' ||
              state.matchedLocation == '/onboarding')) {
        return '/home';
      }
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
