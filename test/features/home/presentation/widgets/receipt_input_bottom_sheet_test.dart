import 'package:budgets/features/home/presentation/pages/chat_home_page.dart';
import 'package:flutter/material.dart';
import 'package:budgets/core/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/home_test_window.dart';

void main() {
  testWidgets('plus opens receipt options without the adjustment control',
      (tester) async {
    usePhoneWindow(tester);
    await tester.pumpWidget(
      MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChatHomePage(today: DateTime(2026, 7, 16))),
    );

    expect(find.byTooltip('Input options'), findsNothing);

    await tester.tap(find.byTooltip('Add receipt'));
    await tester.pumpAndSettle();

    expect(find.text('Import file'), findsOneWidget);
    expect(find.text('Scan receipt'), findsOneWidget);
    expect(find.text('Enter manually'), findsOneWidget);
    final menuStyle = tester.widget<Text>(find.text('Enter manually')).style!;
    expect(menuStyle.fontWeight,
        AppTheme.lightTheme.textTheme.bodyMedium!.fontWeight);
    expect(menuStyle.fontFamily,
        AppTheme.lightTheme.textTheme.bodyMedium!.fontFamily);
    expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
    expect(find.byIcon(Icons.note_add_outlined), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner_outlined), findsOneWidget);

    await tester.tapAt(const Offset(20, 100));
    await tester.pumpAndSettle();
    expect(find.text('Enter manually'), findsNothing);
  });
}
