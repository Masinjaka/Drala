import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/features/guest/presentation/widgets/guest_sync_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
        'guest sign-in prompt is compact and unboxed in ${dark ? 'dark' : 'light'} mode',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: SizedBox(width: 400, child: GuestSyncCard(onSignIn: () {}))),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Connectez-vous pour synchroniser votre budget.'),
          findsOneWidget);
      expect(find.text('Comment souhaitez-vous continuer ?'), findsNothing);
      expect(find.byType(AppCardSurface), findsNothing);
      final button = tester.widget<FilledButton>(
          find.byKey(const Key('guest-settings-sign-in')));
      expect(tester.getSize(find.byType(FilledButton)).width, lessThan(250));
      expect(button.style!.backgroundColor!.resolve({}),
          dark ? Colors.white : Colors.black);
      expect(button.style!.foregroundColor!.resolve({}),
          dark ? Colors.black : Colors.white);
    });
  }
}
