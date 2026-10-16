import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('guest presets match cloud choices and save localized categories',
      () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();

    final presets = await guest.onboarding.presets();
    expect(presets, hasLength(12));
    expect(
        presets.map((preset) => preset.slug),
        containsAll([
          'housing',
          'education',
          'other_expense',
          'other_income',
        ]));
    expect(
      presets.singleWhere((preset) => preset.slug == 'other_income').type,
      'income',
    );

    await guest.onboarding.complete(
      currency: 'MGA',
      language: 'fr',
      categories: const [
        'housing',
        'education',
        'other_expense',
        'other_income',
      ],
      wallets: const [],
    );
    final rows = await database.customSelect(
      '''SELECT name,transaction_type,icon_key FROM guest_categories
         ORDER BY name''',
    ).get();
    expect(rows.map((row) => row.read<String>('name')),
        containsAll(['Logement', 'Éducation', 'Autre', 'Autres revenus']));
    expect(
      rows
          .singleWhere((row) => row.read<String>('name') == 'Autres revenus')
          .read<String>('transaction_type'),
      'income',
    );
    expect(
      rows
          .singleWhere((row) => row.read<String>('name') == 'Autres revenus')
          .read<String>('icon_key'),
      'income',
    );
  });
}
