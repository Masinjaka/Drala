import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('balance banner remains distinct from the dark page',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: HomeBalanceCard(
          balance: 1000,
          income: 0,
          expenses: 0,
          currencyCode: 'MGA',
        ),
      ),
    ));

    final card =
        tester.widget<Container>(find.byKey(const Key('home-balance-card')));
    expect((card.decoration as BoxDecoration).color,
        AppTheme.darkTheme.colorScheme.surfaceContainerLowest);
    expect((card.decoration as BoxDecoration).color,
        isNot(AppTheme.darkTheme.scaffoldBackgroundColor));
  });
}
