import 'dart:async';
import 'package:flutter/cupertino.dart' show CupertinoPicker;

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
    expect(find.byKey(const Key('envelope-title-skeleton')), findsNWidgets(4));
    expect(find.text('Envelope'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('envelope-title-skeleton')).first),
      const Size(88, 16),
    );
    expect(
      tester.getSize(find.byKey(const Key('envelope-spent-skeleton')).first),
      const Size(64, 18),
    );
    expect(
      tester.getSize(find.byKey(const Key('envelope-budget-skeleton')).first),
      const Size(56, 18),
    );
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

  testWidgets('calendar jumps across years and keeps the carousel in sync',
      (tester) async {
    final now = DateTime.now();
    final selected = DateTime(now.year, now.month);
    final repository = _DeferredEnvelopeRepository();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EnvelopePage(repository: repository, initialMonth: selected),
    ));
    await tester.pump();
    repository.completeAll();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('envelope-pick-month')));
    await tester.pumpAndSettle();
    final wheels = find.byType(CupertinoPicker);
    expect(wheels, findsNWidgets(2));
    await tester.drag(wheels.last, const Offset(0, 88));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('app-wheel-picker-done')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    repository.completeAll();
    await tester.pumpAndSettle();

    final pager =
        tester.widget<PageView>(find.byKey(const Key('envelope-month-pages')));
    final page = pager.controller!.page!.round();
    expect(page, lessThan(1200));
    expect(page, greaterThanOrEqualTo(1164));
    final month = DateTime(selected.year, selected.month + page - 1200);
    expect(find.byKey(Key('envelope-${_key(month)}')), findsOneWidget);
    expect(tester.takeException(), isNull);
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
      if (_requests[index].isCompleted) continue;
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
    bool repeatsMonthly = false,
  }) async {}
  @override
  Future<void> updateEnvelope(
      {required String id,
      required String name,
      required String categoryId,
      required int amount,
      required bool repeatsMonthly}) async {}

  @override
  Future<void> deleteEnvelope(String id) async {}
}

String _key(DateTime month) => '${month.year}-${month.month}';
