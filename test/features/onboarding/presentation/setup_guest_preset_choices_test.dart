import 'package:budgets/core/theme.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/onboarding/presentation/widgets/setup_preset_choices.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest can select the localized extra income preset',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    String? selected;

    await tester.pumpWidget(ProviderScope(
      overrides: [guestSessionProvider.overrideWithValue(guest)],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SetupPresetChoices(
              language: 'fr',
              selected: const {},
              onChanged: (slug) => selected = slug,
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final extraIncome = find.text('Autres revenus');
    expect(extraIncome, findsOneWidget);
    expect(find.text('Logement'), findsOneWidget);
    expect(find.text('Éducation'), findsOneWidget);
    await tester.ensureVisible(extraIncome);
    await tester.tap(extraIncome);
    expect(selected, 'other_income');
  });
}
