import 'package:animated_digit/animated_digit.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/widgets/home_dashboard.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../ai_entry/support/fake_ai_entry_repository.dart';
import '../../../notifications/support/fake_finance_notification_repository.dart';
import '../../support/home_test_window.dart';

void main() {
  testWidgets('waits for selected currency before rendering the balance',
      (tester) async {
    usePhoneWindow(tester);
    final repository = FakeAiEntryRepository()
      ..walletItems = const [
        WalletSummary(
          id: 'cash',
          name: 'Cash',
          balance: 1000000,
          currencyCode: 'MGA',
          iconKey: 'wallet',
          isDefault: true,
        ),
      ];
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 25));
    final notifications = FinanceNotificationViewModel(
      FakeFinanceNotificationRepository(),
    );
    addTearDown(viewModel.dispose);
    addTearDown(notifications.dispose);
    await viewModel.loadDate(DateTime(2026, 7, 25));

    var currencyLoading = true;
    CurrencyState? currency;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return Scaffold(
              body: HomeDashboard(
                today: DateTime(2026, 7, 25),
                drawerProgress: const AlwaysStoppedAnimation(0),
                onMenuPressed: () {},
                viewModel: viewModel,
                notificationViewModel: notifications,
                onNotificationsPressed: () {},
                onFinanceChanged: () async {},
                onDateSelected: (_) {},
                currencyState: currency,
                isCurrencyLoading: currencyLoading,
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('-'), findsOneWidget);
    expect(find.text('Ariary'), findsNothing);
    expect(find.byKey(const Key('home-balance-currency')), findsNothing);

    update(() {
      currencyLoading = false;
      currency = const CurrencyState(
        code: 'USD',
        baseCode: 'MGA',
        rates: {'USD': 0.00022},
      );
    });
    await tester.pump();

    expect(find.text('Ariary'), findsNothing);
    expect(find.text('USD'), findsOneWidget);
    final counter = tester.widget<AnimatedDigitWidget>(
      find.byType(AnimatedDigitWidget),
    );
    expect(counter.controller?.value, closeTo(220, 0.001));

    await tester.pumpAndSettle();
    expect(find.text('Ariary'), findsNothing);
  });
}
