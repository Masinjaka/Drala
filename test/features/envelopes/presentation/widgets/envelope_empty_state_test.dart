import 'package:budgets/features/envelopes/presentation/widgets/envelope_empty_state.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_month_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('centers the empty envelope illustration in the list area',
      (tester) async {
    var creates = 0;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: EnvelopeMonthPage(
          onAdd: () => creates++,
          envelopes: const [],
          isLoading: false,
          onRefresh: () async {},
          onDelete: (_) {},
        ),
      ),
    ));

    final empty = find.byType(EnvelopeEmptyState);
    expect(empty, findsOneWidget);
    expect(find.text('Give your plans a little room to grow.'), findsOneWidget);
    expect(tester.getCenter(empty).dy, closeTo(284, 1));
    expect(find.byType(Card), findsNothing);
    await tester.tap(find.text('Create envelope'));
    expect(creates, 1);
  });
}
