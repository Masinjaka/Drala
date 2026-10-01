import 'package:budgets/features/home/presentation/widgets/chat_typing_hint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('types, idles, erases, and advances to the next suggestion',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ChatTypingHint(
          suggestions: ['Expense', 'Income', 'Transfer'],
          style: TextStyle(fontSize: 12),
          animate: true,
        ),
      ),
    ));

    String visibleText() => tester
        .widget<RichText>(find.byKey(const Key('chat-typing-hint-text')))
        .text
        .toPlainText();

    expect(visibleText(), '|');
    final textSpan = tester
        .widget<RichText>(find.byKey(const Key('chat-typing-hint-text')))
        .text as TextSpan;
    expect(textSpan.style?.fontSize, 11);
    expect((textSpan.children![1] as TextSpan).style?.fontSize, 12);
    await tester.pump(const Duration(milliseconds: 220));
    expect(visibleText(), startsWith('Expe'));
    expect(visibleText(), endsWith('|'));

    await tester.pump(const Duration(milliseconds: 220));
    expect(visibleText(), startsWith('Expense'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(visibleText().length, lessThan('Expense|'.length));

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 110));
    expect(visibleText(), startsWith('In'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion keeps a stable first suggestion', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: ChatTypingHint(
          suggestions: ['Expense', 'Income', 'Transfer'],
          style: TextStyle(fontSize: 12),
          animate: true,
        ),
      ),
    ));

    expect(find.text('Expense'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Expense'), findsOneWidget);
  });
}
