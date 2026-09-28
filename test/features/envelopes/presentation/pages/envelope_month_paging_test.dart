import 'dart:async';

import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps the month wheel visible while month pages load',
      (tester) async {
    final now = DateTime.now();
    final selected = DateTime(now.year, now.month - 1);
    final repository = _DeferredEnvelopeRepository();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EnvelopePage(repository: repository, initialMonth: selected),
    ));
    await tester.pump();

    expect(find.byKey(const Key('month-carousel')), findsOneWidget);
    expect(find.byKey(const Key('envelope-month-pages')), findsOneWidget);
    expect(find.byKey(const Key('envelope-skeleton-card')), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    repository.completeAll();
    await tester.pumpAndSettle();
    expect(find.byKey(Key('envelope-${_key(selected)}')), findsOneWidget);

    await tester.fling(
      find.byKey(const Key('envelope-month-pages')),
      const Offset(600, 0),
      1200,
    );
    await tester.pumpAndSettle();
    final previous = DateTime(selected.year, selected.month - 1);
    expect(find.byKey(Key('envelope-${_key(previous)}')), findsOneWidget);
    expect(find.byKey(const Key('envelope-skeleton-card')), findsNothing);
  });
}

class _DeferredEnvelopeRepository implements EnvelopeRepository {
  final _requests = <Completer<List<Envelope>>>[];
  final _months = <DateTime>[];

  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) {
    final request = Completer<List<Envelope>>();
    _requests.add(request);
    _months.add(month);
    return request.future;
  }

  void completeAll() {
    for (var index = 0; index < _requests.length; index++) {
      final month = _months[index];
      _requests[index].complete([
        Envelope(
          id: _key(month),
          name: _key(month),
          categoryId: 'food',
          categoryName: 'Food',
          emoji: '🍔',
          color: 'FFFFFFFF',
          amount: 100,
          spent: 20,
          currencyCode: 'MGA',
        ),
      ]);
    }
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

String _key(DateTime month) => '${month.year}-${month.month}';
