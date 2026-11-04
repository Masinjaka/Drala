import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_toast_overlay.dart';
import 'package:budgets/features/home/presentation/widgets/manual_entry_sheet.dart';
import 'package:budgets/features/home/presentation/widgets/add_wallet_sheet.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets(
        'manual finance fields report all missing values inline in ${theme.brightness}',
        (tester) async {
      await _open(
          tester,
          theme,
          (context) => ManualEntrySheet.show(context,
              categories: Future.value(const []),
              targetDate: DateTime(2026, 10, 23)));
      await tester.ensureVisible(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('save-transaction')));
      await tester.pumpAndSettle();
      expect(find.text('This field is required.'), findsNWidgets(2));
      expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
      expect(find.byType(AppToastOverlay), findsNothing);
      await tester.enterText(find.byType(TextFormField).at(1), 'Internet');
      await tester.enterText(find.byType(TextFormField).first, '100');
      await tester.pumpAndSettle();
      expect(find.text('This field is required.'), findsOneWidget);
      expect(find.text('Enter an amount greater than zero.'), findsNothing);
      expect(find.byType(ManualEntrySheet), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'wallet name validates inline while an empty starting balance stays optional in ${theme.brightness}',
        (tester) async {
      await _open(tester, theme, (context) => AddWalletSheet.show(context));
      await tester.ensureVisible(find.byKey(const Key('confirm-add-wallet')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-add-wallet')));
      await tester.pumpAndSettle();
      expect(find.text('This field is required.'), findsOneWidget);
      expect(find.byType(AppToastOverlay), findsNothing);
      await tester.enterText(find.byType(TextFormField).at(1), 'Cash');
      await tester.ensureVisible(find.byKey(const Key('confirm-add-wallet')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-add-wallet')));
      await tester.pumpAndSettle();
      expect(find.byType(AddWalletSheet), findsNothing);
    });
  }
}

Future<void> _open(WidgetTester tester, ThemeData theme,
    Future<Object?> Function(BuildContext) open) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
    theme: theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
        body: Builder(
            builder: (context) => TextButton(
                onPressed: () => open(context), child: const Text('Open')))),
  )));
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
