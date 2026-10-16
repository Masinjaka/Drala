import 'package:budgets/core/theme.dart';
import 'package:budgets/features/settings/presentation/widgets/guest_currency_rate_notice.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('explains why offline amounts remain in MGA', (tester) async {
    var retries = 0;
    await tester.pumpWidget(MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: GuestCurrencyRateNotice(
          preferred: 'EUR',
          displayed: 'MGA',
          onRetry: () => retries++,
        ),
      ),
    ));

    expect(
      find.text(
        'EUR is saved. Amounts stay in MGA until exchange rates are available.',
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('uses the app theme in dark mode', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: GuestCurrencyRateNotice(
          preferred: 'EUR',
          displayed: 'MGA',
          onRetry: _noRetry,
        ),
      ),
    ));

    final text = tester.widget<Text>(find.textContaining('EUR is saved'));
    expect(
      text.style?.fontFamily,
      AppTheme.darkTheme.textTheme.bodyMedium?.fontFamily,
    );
  });
}

void _noRetry() {}
