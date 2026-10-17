import 'dart:async';

import 'package:budgets/core/navigation/app_navigation.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/pages/guest_account_choice_page.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest sign in choice offers login and signup only',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    final authChanges = StreamController<Object?>.broadcast();
    final navigation = AppNavigation(
      isSignedIn: () => false,
      authChanges: authChanges.stream,
      guestSession: guest,
    );
    addTearDown(() async {
      navigation.dispose();
      await authChanges.close();
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(guest)],
      child: MaterialApp.router(routerConfig: navigation.router),
    ));
    navigation.router.go('/sign-in-choice');
    await tester.pumpAndSettle();

    final choice = tester.widget<GuestAccountChoicePage>(
      find.byType(GuestAccountChoicePage),
    );
    expect(choice.showGuestOption, false);
    final l10n = tester.element(find.byType(GuestAccountChoicePage)).l10n;
    expect(find.text(l10n.authSignUp), findsOneWidget);
    expect(find.text(l10n.authSignIn), findsOneWidget);
    expect(find.text(l10n.guestContinue), findsNothing);
    expect(find.text(l10n.guestChoiceBody), findsNothing);
  });
}
