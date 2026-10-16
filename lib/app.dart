import 'dart:async';

import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_responsive_scope.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/feedback/presentation/widgets/app_feedback.dart';
import 'package:budgets/features/guest/data/guest_cloud_sync_service.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:budgets/features/settings/data/services/cloud_appearance_preferences.dart';
import 'package:budgets/features/settings/domain/providers/locale_provider.dart';
import 'package:budgets/features/settings/domain/providers/theme_provider.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    required this.navigation,
    this.guestSession,
    this.authClient,
    super.key,
  });

  final AppNavigation navigation;
  final GuestSession? guestSession;
  final SupabaseClient? authClient;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _amountVisibilityController = AmountVisibilityController();
  StreamSubscription<AuthState>? _authSubscription;
  String? _lastCloudAppearance;

  @override
  void initState() {
    super.initState();
    final client = widget.authClient;
    if (client == null) return;
    _authSubscription = client.auth.onAuthStateChange.listen((state) {
      if (state.session == null) {
        _lastCloudAppearance = null;
      } else {
        unawaited(_restoreCloudAppearance());
        final guest = widget.guestSession;
        if (guest?.isActive == true && guest!.onboardingComplete) {
          unawaited(_resumeGuestSync(guest));
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_restoreCloudAppearance());
    });
    final guest = widget.guestSession;
    if (guest?.isActive == true &&
        guest!.onboardingComplete &&
        client.auth.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_resumeGuestSync(guest));
      });
    }
  }

  Future<void> _restoreCloudAppearance() async {
    if (!mounted || widget.guestSession?.isActive == true) return;
    final client = widget.authClient;
    if (client == null) return;
    try {
      final appearance = CloudAppearancePreferences(client).current;
      final key = '${appearance.language}|${appearance.theme}';
      if (key == _lastCloudAppearance) return;
      final locale = ref.read(localeProvider.notifier);
      await locale.ready;
      if (!mounted) return;
      if (appearance.language case final String language
          when supportedAppLocales.any((l) => l.languageCode == language)) {
        if (ref.read(localeProvider).languageCode != language) {
          await locale.setLocale(Locale(language));
        }
      }
      final theme = ThemeOptions.values.where(
        (option) => option.name == appearance.theme,
      );
      if (theme.isNotEmpty &&
          ref.read(themeProvider).name != theme.first.name) {
        await ref.read(themeProvider.notifier).setTheme(theme.first);
      }
      _lastCloudAppearance = key;
    } catch (error, stackTrace) {
      Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  Future<void> _resumeGuestSync(GuestSession guest) async {
    try {
      await GuestCloudSyncService(widget.authClient!, guest).sync();
      if (!mounted) return;
      ref.invalidate(guestSessionProvider);
      ref.invalidate(categoriesProvider);
      ref.invalidate(currencyControllerProvider);
      ref.invalidate(userModelProvider);
      ref.invalidate(notificationControllerProvider);
      unawaited(_restoreCloudAppearance());
    } catch (error, stackTrace) {
      Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _amountVisibilityController.dispose();
    widget.navigation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    return AppFeedback(
      themeMode: themeMode,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        locale: locale,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          const MalagasyMaterialLocalizationsDelegate(),
          const MalagasyCupertinoLocalizationsDelegate(),
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        builder: (context, child) {
          final content = AmountVisibilityScope(
            controller: _amountVisibilityController,
            child: AppResponsiveScope(
              child: child ?? const SizedBox.shrink(),
            ),
          );
          final guest = widget.guestSession;
          if (guest == null) return content;
          return AnimatedBuilder(
            animation: guest,
            child: content,
            builder: (context, child) => Stack(children: [
              AbsorbPointer(absorbing: guest.isSyncing, child: child!),
              if (guest.isSyncing)
                const Center(child: CircularProgressIndicator()),
            ]),
          );
        },
        routerConfig: widget.navigation.router,
      ),
    );
  }
}
