import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:budgets/features/onboarding/domain/models/category_preset_names.dart';
import 'package:drift/drift.dart';

/// Fictional demo data for the Play Store screenshots (no real user data).
Future<void> seedDemoData(GuestSession guest, DateTime today) async {
  await guest.start();
  await guest.onboarding.complete(
    currency: 'MGA',
    language: 'fr',
    categories: categoryPresetNames.keys.toList(),
    wallets: const ['cash', 'bank', 'mobile'],
  );
  guest.markOnboardingComplete();
  await guest.markChoiceSeen();
  final db = guest.database;
  Future<String> id(String table, String name) async =>
      (await db.customSelect('SELECT id FROM $table WHERE name = ?',
              variables: [Variable.withString(name)]).getSingle())
          .read<String>('id');
  final bank = await id('guest_wallets', 'Compte bancaire');
  final cash = await id('guest_wallets', 'Espèces');
  final mobile = await id('guest_wallets', 'Mobile money');
  final main = await id('guest_wallets', 'Portefeuille principal');
  await guest.repositories.wallets.setDefault(bank);
  await guest.repositories.wallets.delete(main);
  final cat = <String, String>{};
  for (final slug in categoryPresetNames.keys) {
    cat[slug] = await id('guest_categories', categoryPresetNames[slug]!['fr']!);
  }
  final repo = guest.repositories;
  Future<void> entry(String title, int amount, String slug, DateTime at,
      {String? wallet, String type = 'expense'}) async {
    await repo.mutations.add(ManualEntryInput(
      title: title,
      amount: amount,
      transactionType: type,
      occurredAt: at,
      categoryId: cat[slug],
      sourceWalletId: wallet,
      useAllWallets: wallet == null,
    ));
  }

  DateTime day(int monthOffset, int d, [int h = 12]) =>
      DateTime(today.year, today.month - monthOffset, d, h);

  // Two previous months, so the stats can compare periods.
  for (final back in [2, 1]) {
    final f = back == 2 ? 1.0 : 1.08;
    await entry('Salaire', 2400000, 'salary', day(back, 1, 9),
        wallet: bank, type: 'income');
    await entry('Loyer', 650000, 'housing', day(back, 3), wallet: bank);
    await entry(
        'Courses du mois', (310000 * f).round(), 'shopping', day(back, 6),
        wallet: bank);
    await entry('Restaurants', (240000 * f).round(), 'food', day(back, 12));
    await entry(
        'Taxi-be et taxi', (105000 * f).round(), 'transport', day(back, 14));
    await entry('Facture Jirama', 88000, 'utilities', day(back, 10),
        wallet: bank);
    await entry(
        'Sortie cinéma', (60000 * f).round(), 'entertainment', day(back, 20));
    await entry('Pharmacie', 35000, 'health', day(back, 22));
  }

  // Current month: incomes first so envelopes and expenses can be funded.
  await entry('Salaire', 2400000, 'salary', day(0, 1, 9),
      wallet: bank, type: 'income');
  await entry('Paiement client', 450000, 'freelance', day(0, today.day, 15),
      wallet: mobile, type: 'income');
  await entry('Vente en ligne', 300000, 'other_income', day(0, 2, 11),
      wallet: cash, type: 'income');
  final month = DateTime(today.year, today.month);
  for (final (slug, amount) in [
    ('food', 300000),
    ('shopping', 350000),
    ('transport', 120000),
    ('entertainment', 80000),
    ('utilities', 150000),
  ]) {
    await repo.envelopeMutations.add(
        name: categoryPresetNames[slug]!['fr']!,
        categoryId: cat[slug]!,
        amount: amount,
        month: month,
        walletId: bank,
        repeatsMonthly: true);
  }
  for (final (title, amount, slug, d, h, wallet) in [
    ('Loyer', 650000, 'housing', 3, 10, bank),
    ('Courses Shoprite', 182000, 'shopping', 8, 17, null),
    ('Facture Jirama', 94000, 'utilities', 10, 9, null),
    ('Frais de scolarité', 120000, 'education', 4, 9, bank),
    ('Marché Analakely', 46500, 'shopping', 15, 8, cash),
    ('Cinéma entre amis', 45000, 'entertainment', 9, 20, null),
    ('Concert', 30000, 'entertainment', 16, 21, null),
    ('Pharmacie', 27500, 'health', 12, 18, cash),
    ('Déjeuner au resto', 32000, 'food', 12, 13, null),
    ('Pizza du vendredi', 54000, 'food', 14, 20, null),
    ('Taxi-be', 18000, 'transport', 11, 7, cash),
    ('Carburant scooter', 40000, 'transport', 17, 8, null),
    ('Courses de la semaine', 68000, 'shopping', 18, 18, null),
    ('Supermarché', 62000, 'shopping', 18, 19, null),
    ('Taxi aéroport', 47000, 'transport', 18, 6, null),
    ('Petit-déjeuner', 8000, 'food', today.day, 8, cash),
    ('Taxi', 15000, 'transport', today.day, 9, cash),
    ('Déjeuner', 25000, 'food', today.day, 13, null),
    ('Café', 5000, 'food', today.day, 10, cash),
    ('Recharge téléphone', 10000, 'utilities', today.day, 11, null),
  ]) {
    await entry(title, amount, slug, day(0, d, h), wallet: wallet);
  }
}
