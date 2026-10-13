import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a neutral date wheel and returns the selected date',
      (tester) async {
    DateTime? selected;
    final initial = DateTime(2026, 7, 21);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) => FilledButton(
            onPressed: () async {
              selected = await AppWheelPicker.date(
                context,
                initialDate: initial,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app-sheet-surface')), findsOneWidget);
    final title = tester.widget<Text>(
      find.byKey(const Key('app-wheel-picker-title')),
    );
    final done = tester.widget<FilledButton>(
      find.descendant(
        of: find.byKey(const Key('app-wheel-picker-done')),
        matching: find.byType(FilledButton),
      ),
    );
    expect(title.style?.color, AppTheme.lightTheme.colorScheme.onSurface);
    expect(done.style?.backgroundColor?.resolve({}), Colors.black);

    await tester.tap(find.byKey(const Key('app-wheel-picker-done')));
    await tester.pumpAndSettle();
    expect(selected, initial);
  });

  testWidgets('shows the same wheel treatment for time selection',
      (tester) async {
    TimeOfDay? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) => FilledButton(
            onPressed: () async {
              selected = await AppWheelPicker.time(
                context,
                initialTime: const TimeOfDay(hour: 8, minute: 30),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('app-wheel-picker-done')), findsOneWidget);

    await tester.tap(find.byKey(const Key('app-wheel-picker-done')));
    await tester.pumpAndSettle();
    expect(selected, const TimeOfDay(hour: 8, minute: 30));
  });

  testWidgets('localizes the confirmation action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => FilledButton(
            onPressed: () => AppWheelPicker.monthYear(
              context,
              initialDate: DateTime(2026, 7),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Terminé'), findsOneWidget);
    expect(find.text('Done'), findsNothing);
  });
}
