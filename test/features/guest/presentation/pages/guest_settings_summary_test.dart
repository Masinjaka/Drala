import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/guest/presentation/pages/guest_settings_page.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_summary_card.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest settings keeps category and wallet summary actions',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    await guest.onboarding.complete(
      currency: 'MGA',
      language: 'en',
      categories: const ['food'],
      wallets: const ['cash'],
    );
    guest.markOnboardingComplete();
    final walletChanges = ChangeNotifier();
    addTearDown(walletChanges.dispose);
    var categoriesOpened = 0;
    var walletsOpened = 0;

    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(guest)],
      child: MaterialApp(
        home: GuestSettingsPage(
          isSignedIn: () => false,
          walletsListenable: walletChanges,
          walletCountReader: () => 2,
          onCategoriesPressed: () => categoriesOpened++,
          onWalletsPressed: () => walletsOpened++,
        ),
      ),
    ));
    await tester.pump();

    expect(find.byType(SettingsSummaryCard), findsNWidgets(2));
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Wallets'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Categories'));
    await tester.tap(find.text('Wallets'));
    expect(categoriesOpened, 1);
    expect(walletsOpened, 1);
  });
}
