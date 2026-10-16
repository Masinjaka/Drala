import 'dart:convert';

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/onboarding/domain/models/category_preset_names.dart';
import 'package:budgets/features/onboarding/domain/models/onboarding_preset.dart';
import 'package:budgets/features/onboarding/domain/models/wallet_preset_names.dart';
import 'package:budgets/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestOnboardingRepository implements OnboardingRepository {
  GuestOnboardingRepository(this.database, this.userId);

  final GuestDatabase database;
  final String userId;
  Map<String, dynamic> _draft = {};

  Future<void> loadDraft() async {
    final rows = await database.customSelect(
      'SELECT value FROM guest_preferences WHERE key = ?',
      variables: [Variable.withString('onboarding_draft')],
    ).get();
    if (rows.isNotEmpty) {
      _draft = Map<String, dynamic>.from(
        jsonDecode(rows.single.read<String>('value')) as Map,
      );
    }
  }

  @override
  Map<String, dynamic> get draft => _draft;

  @override
  Future<List<OnboardingPreset>> presets() async => [
        for (final slug in categoryPresetNames.keys)
          OnboardingPreset(
            slug: slug,
            name: categoryPresetNames[slug]!['en']!,
            type: _income.contains(slug) ? 'income' : 'expense',
            icon: _iconKey[slug] ?? slug,
          ),
      ];

  @override
  Future<void> save(Map<String, dynamic> draft) async {
    _draft = Map<String, dynamic>.from(draft);
    await database.customInsert(
      '''INSERT INTO guest_preferences(key,value,updated_at) VALUES(?,?,?)
         ON CONFLICT(key) DO UPDATE SET value=excluded.value,
         updated_at=excluded.updated_at''',
      variables: [
        Variable.withString('onboarding_draft'),
        Variable.withString(jsonEncode(draft)),
        Variable.withString(DateTime.now().toUtc().toIso8601String()),
      ],
    );
  }

  @override
  Future<void> complete({
    required String currency,
    required String language,
    required List<String> categories,
    required List<String> wallets,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      final profile = await database.customSelect(
        'SELECT onboarding_complete FROM guest_profiles WHERE id = ?',
        variables: [Variable.withString(userId)],
      ).getSingle();
      if (profile.read<int>('onboarding_complete') == 1) return;
      await database.customUpdate(
        '''UPDATE guest_profiles SET currency_code=?,language_code=?,
           onboarding_complete=1 WHERE id=?''',
        variables: [
          Variable.withString(currency),
          Variable.withString(language),
          Variable.withString(userId),
        ],
      );
      await GuestSyncJournal(database).record('user', userId, 'upsert', {
        'currency_code': currency,
        'language_code': language,
      });
      for (final slug in categories.toSet()) {
        if (!categoryPresetNames.containsKey(slug)) continue;
        final id = const Uuid().v4();
        final type = _income.contains(slug) ? 'income' : 'expense';
        final name = categoryPresetNames[slug]![language] ??
            categoryPresetNames[slug]!['en']!;
        final emoji = _emoji[slug] ?? '🧾';
        final color = _color[slug] ?? 'FF9E9E9E';
        await database.customInsert(
          '''INSERT INTO guest_categories
             (id,user_id,name,transaction_type,emoji,color,icon_key,created_at,updated_at)
             VALUES(?,?,?,?,?,?,?,?,?)''',
          variables: [
            Variable.withString(id),
            Variable.withString(userId),
            Variable.withString(name),
            Variable.withString(type),
            Variable.withString(emoji),
            Variable.withString(color),
            Variable.withString(_iconKey[slug] ?? slug),
            Variable.withString(now),
            Variable.withString(now),
          ],
        );
        await GuestSyncJournal(database).record('categories', id, 'upsert', {
          'id': id,
          'name': name,
          'transaction_type': type,
          'emoji': emoji,
          'color': color,
          'icon_key': _iconKey[slug] ?? slug,
        });
      }
      for (final slug in {'main', ...wallets}) {
        if (!walletPresetNames.containsKey(slug)) continue;
        final id = const Uuid().v4();
        final name = walletPresetNames[slug]![language] ??
            walletPresetNames[slug]!['en']!;
        final isDefault = slug == 'main';
        await database.customInsert(
          '''INSERT INTO guest_wallets
             (id,user_id,name,balance,currency_code,icon_key,is_default,created_at,updated_at)
             VALUES(?,?,?,0,'MGA',?,?,?,?)''',
          variables: [
            Variable.withString(id),
            Variable.withString(userId),
            Variable.withString(name),
            Variable.withString(slug == 'main' ? 'wallet' : slug),
            Variable.withInt(isDefault ? 1 : 0),
            Variable.withString(now),
            Variable.withString(now),
          ],
        );
        await GuestSyncJournal(database).record('wallets', id, 'upsert', {
          'id': id,
          'name': name,
          'balance': 0,
          'currency_code': 'MGA',
          'icon_key': slug == 'main' ? 'wallet' : slug,
          'is_default': isDefault,
        });
      }
      await database.customUpdate(
        'DELETE FROM guest_preferences WHERE key = ?',
        variables: [Variable.withString('onboarding_draft')],
      );
      _draft = {};
    });
  }
}

const _income = {'salary', 'freelance', 'other_income'};
const _iconKey = {'other_expense': 'other', 'other_income': 'income'};
const _emoji = {
  'food': '🍔',
  'shopping': '🛒',
  'transport': '🚕',
  'housing': '🏠',
  'health': '🏥',
  'utilities': '💡',
  'entertainment': '🎬',
  'education': '🎓',
  'salary': '💼',
  'freelance': '🧑‍💻',
  'other_expense': '🧾',
  'other_income': '💰',
};
const _color = {
  'food': 'FFFF9800',
  'shopping': 'FF9C27B0',
  'transport': 'FF2196F3',
  'housing': 'FF795548',
  'health': 'FFF44336',
  'utilities': 'FF607D8B',
  'entertainment': 'FF673AB7',
  'education': 'FF3F51B5',
  'salary': 'FF4CAF50',
  'freelance': 'FF009688',
  'other_expense': 'FF9E9E9E',
  'other_income': 'FF8BC34A',
};
