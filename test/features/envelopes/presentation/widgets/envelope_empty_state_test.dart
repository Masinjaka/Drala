import 'package:budgets/features/envelopes/presentation/widgets/envelope_empty_state.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_month_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('centers the empty envelope illustration in the list area',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: EnvelopeMonthPage(
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
    expect(tester.getCenter(empty).dy, closeTo(300, 1));
    expect(find.byType(Card), findsNothing);
    expect(find.text('Create envelope'), findsNothing);
    final center = tester.getCenter(empty);
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -120));
    await tester.pumpAndSettle();
    expect(tester.getCenter(empty), center);
  });
}
