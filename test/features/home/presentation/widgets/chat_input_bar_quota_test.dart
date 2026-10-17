import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('quota exhaustion offers manual entry while chat is idle',
      (tester) async {
    var manualRequests = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ChatInputBar(
          isSubmitting: false,
          isQuotaExhausted: true,
          onSubmit: (_) async => true,
          onManualEntryRequested: () async => manualRequests++,
        ),
      ),
    ));

    expect(find.byKey(const Key('manual-entry-send')), findsOneWidget);
    expect(find.byKey(const Key('ai-send')), findsNothing);
    await tester.tap(find.byTooltip('Manual entry'));
    await tester.pump();
    expect(manualRequests, 1);
  });

  testWidgets('active signed-in chat shows send and submits its message',
      (tester) async {
    String? submitted;
    var manualRequests = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ChatInputBar(
          isSubmitting: false,
          isQuotaExhausted: true,
          onSubmit: (message) async {
            submitted = message;
            return true;
          },
          onManualEntryRequested: () async => manualRequests++,
        ),
      ),
    ));

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ai-send')), findsOneWidget);
    expect(find.byKey(const Key('manual-entry-send')), findsNothing);

    await tester.enterText(find.byType(TextField), 'Lunch 24 000 Ar');
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ai-send')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ai-send')));
    await tester.pumpAndSettle();
    expect(submitted, 'Lunch 24 000 Ar');
    expect(manualRequests, 0);
    expect(find.byKey(const Key('manual-entry-send')), findsOneWidget);
  });
}
