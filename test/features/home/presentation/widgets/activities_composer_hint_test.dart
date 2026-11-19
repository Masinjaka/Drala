import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:budgets/features/home/presentation/widgets/chat_typing_hint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'embedded Activities composer animates all suggestions until focused',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
            body: ChatInputBar(
                embedded: true,
                isSubmitting: false,
                onSubmit: (_) async => true,
                onManualEntryRequested: () async {}))));
    final hint = tester.widget<ChatTypingHint>(find.byType(ChatTypingHint));
    expect(hint.animate, isTrue);
    expect(hint.suggestions, hasLength(3));
    await tester.pump(const Duration(milliseconds: 220));
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    final focused = tester.widget<ChatTypingHint>(find.byType(ChatTypingHint));
    expect(focused.animate, isFalse);
    expect(focused.suggestions, ['Start typing...']);
  });
}
