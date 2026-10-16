import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('guest composer offers manual entry from both actions',
      (tester) async {
    var manualRequests = 0;
    var aiRequests = 0;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ChatInputBar(
          manualOnly: true,
          isSubmitting: false,
          onSubmit: (_) async {
            aiRequests++;
            return true;
          },
          onManualEntryRequested: () async {
            manualRequests++;
          },
        ),
      ),
    ));

    expect(find.byKey(const Key('manual-entry-send')), findsOneWidget);
    expect(find.byTooltip('Manual entry'), findsNWidgets(2));
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    await tester.tap(find.byKey(const Key('manual-entry-send')));
    await tester.pump();

    expect(manualRequests, 2);
    expect(aiRequests, 0);
  });
}
