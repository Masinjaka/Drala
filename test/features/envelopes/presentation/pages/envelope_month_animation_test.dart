import 'package:budgets/core/ui/month_carousel.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import '../../support/editable_envelope_repository.dart';

void main() {
  testWidgets('reference month tabs keep their animated paging',
      (tester) async {
    final now = DateTime.now();
    final initial = DateTime(now.year, now.month - 1);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EnvelopePage(
          repository: EditableEnvelopeRepository(),
          initialMonth: initial,
          showBackButton: false),
    ));
    await tester.pumpAndSettle();
    final carousel = find.descendant(
        of: find.byType(MonthCarousel), matching: find.byType(PageView));
    final controller = tester.widget<PageView>(carousel).controller!;
    final start = controller.page!;
    await tester.tap(find.text(DateFormat.MMMM('en').format(now)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.page!, greaterThan(start));
    expect(controller.page!, lessThan(start + 1));
    await tester.pumpAndSettle();
    expect(controller.page, start + 1);
    final pager =
        tester.widget<PageView>(find.byKey(const Key('envelope-month-pages')));
    expect(pager.controller!.page, 1201);
    expect(tester.takeException(), isNull);
  });
}
