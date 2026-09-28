import 'package:budgets/core/theme.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matches the Figma envelope frame', (tester) async {
    _setFigmaViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EnvelopePage(
          repository: _EnvelopeRepository(),
          initialMonth: DateTime(2026, 9),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/envelope_figma.png'),
    );
  });
}

void _setFigmaViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 917);
  tester.view.padding = const FakeViewPadding(top: 24);
  tester.view.viewPadding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.reset);
}

class _EnvelopeRepository implements EnvelopeRepository {
  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) async {
    const names = [
      ('Food', '🍔'),
      ('Groceries', '🛒'),
      ('Transportation', '🚕'),
      ('Cold days', '🧥'),
    ];
    return List.generate(
      names.length,
      (index) => Envelope(
        id: '$index',
        name: names[index].$1,
        categoryId: '$index',
        categoryName: names[index].$1,
        emoji: names[index].$2,
        color: index == 1 ? 'FF343434' : 'FFFFFFFF',
        amount: 500000,
        spent: 250000,
        currencyCode: 'MGA',
      ),
    );
  }

  @override
  Future<List<EnvelopeCategory>> expenseCategories() async => const [];
  @override
  Future<List<WalletSummary>> wallets() async => const [];
  @override
  Future<void> addEnvelope({
    required String name,
    required String categoryId,
    required int amount,
    required DateTime month,
    String? walletId,
  }) async {}
  @override
  Future<void> deleteEnvelope(String id) async {}
}
