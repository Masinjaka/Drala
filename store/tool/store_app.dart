import 'package:budgets/core/localization/fallback_localization_delegates.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_responsive_scope.dart';
import 'package:budgets/features/ai_entry/domain/repositories/ai_entry_repository.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The real home shell, wired to the seeded guest repositories.
Widget storeApp({
  required GuestSession guest,
  required DateTime today,
  required AmountVisibilityController visibility,
  bool dark = false,
  bool asGuest = true,
  AiEntryRepository? aiRepository,
  CurrencyState? currency,
  Locale locale = const Locale('fr'),
}) {
  final repos = guest.repositories;
  return ProviderScope(
    overrides: [guestSessionProvider.overrideWithValue(guest)],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        MalagasyMaterialLocalizationsDelegate(),
        MalagasyCupertinoLocalizationsDelegate(),
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) => AmountVisibilityScope(
        controller: visibility,
        child: AppResponsiveScope(child: child!),
      ),
      home: ChatHomePage(
        today: today,
        displayName: asGuest ? null : 'Fara',
        isGuest: asGuest,
        currencyState: currency,
        isSignedIn: () => !asGuest,
        aiEntryRepository: aiRepository ?? repos.finance,
        envelopeRepository: repos.envelopeRepository,
        statsRepository: repos.stats,
        notificationRepository:
            GuestNotificationRepository(guest.database, guest.userId),
      ),
    ),
  );
}
