import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/chat_input_bar.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('focus expands composer without showing suggestion popup',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: ChatInputBar(
              isSubmitting: false,
              onManualEntryRequested: () async {},
              onSubmit: (_) async => true,
            ),
          ),
        ),
      ),
    );

    final composer = find.byKey(const Key('chat-input-container'));
    final initialHeight = tester.getSize(composer).height;
    expect(initialHeight, 48);
    expect(find.byKey(const Key('chat-input-suggestions')), findsNothing);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('chat-input-suggestions')), findsNothing);
    expect(tester.getSize(composer).height, 85);
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty);
    final focusedHint = tester.widget<Text>(
      find.byKey(const Key('chat-typing-hint-text')),
    );
    expect(focusedHint.data, 'Start typing...');
    expect(focusedHint.style?.fontSize, 14);
    expect(focusedHint.style?.fontWeight, FontWeight.w400);
    await tester.pump(const Duration(seconds: 2));
    expect(
      tester.widget<Text>(find.byKey(const Key('chat-typing-hint-text'))).data,
      focusedHint.data,
    );
  });

  testWidgets('focused hint follows the selected language', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ChatInputBar(
            isSubmitting: false,
            onManualEntryRequested: () async {},
            onSubmit: (_) async => true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    final focusedHint = tester.widget<Text>(
      find.byKey(const Key('chat-typing-hint-text')),
    );
    expect(focusedHint.data, 'Commencez à écrire...');
    expect(focusedHint.style?.fontWeight, FontWeight.w400);
  });

  testWidgets('outside tap dismisses focus without activating content below',
      (tester) async {
    var contentTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: InkWell(
                  key: const Key('content-below-composer'),
                  onTap: () => contentTapped = true,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ChatInputBar(
                  isSubmitting: false,
                  onManualEntryRequested: () async {},
                  onSubmit: (_) async => true,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byType(TextField)).focusNode?.hasFocus,
        isTrue);

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(find.byType(TextField)).focusNode?.hasFocus,
        isFalse);
    expect(contentTapped, isFalse);

    await tester.tapAt(const Offset(20, 20));
    expect(contentTapped, isTrue);
  });

  testWidgets('uses a black cursor', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ChatInputBar(
            isSubmitting: false,
            onManualEntryRequested: () async {},
            onSubmit: (_) async => true,
          ),
        ),
      ),
    );

    expect(
      tester.widget<TextField>(find.byType(TextField)).cursorColor,
      Colors.black,
    );
  });

  testWidgets('animated hint is smaller than entered text with muted color',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ChatInputBar(
            isSubmitting: false,
            onManualEntryRequested: () async {},
            onSubmit: (_) async => true,
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(
      find.byKey(const Key('chat-typing-hint-text')),
    );
    final style = richText.text.style!;
    expect(style.fontFamily, 'Alexandria');
    expect(style.fontSize, 13);
    expect(style.fontWeight, FontWeight.w400);
    expect(style.height, 1.35);
    expect(style.color, AppTheme.mutedTextLight.withValues(alpha: 0.78));
  });

  testWidgets('entered text uses readable regular app typography',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ChatInputBar(
            isSubmitting: false,
            onManualEntryRequested: () async {},
            onSubmit: (_) async => true,
          ),
        ),
      ),
    );

    final style = tester.widget<TextField>(find.byType(TextField)).style!;
    expect(style.fontFamily, 'Alexandria');
    expect(style.fontSize, 14);
    expect(style.fontWeight, FontWeight.w400);
    expect(style.height, 1.35);
  });
}
