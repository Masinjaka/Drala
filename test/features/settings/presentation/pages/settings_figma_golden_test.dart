import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/presentation/view_models/finance_notification_view_model.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_content.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_page_header.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_profile_header.dart';
import 'package:budgets/features/user/domain/models/user_model.dart';
import 'package:budgets/features/user/domain/provider/user_providers.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/load_app_fonts.dart';
import '../../../notifications/support/fake_finance_notification_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });

  testWidgets('matches the Figma settings frame', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(412, 917);
    tester.view.padding = const FakeViewPadding(top: 24);
    tester.view.viewPadding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.reset);

    final notifications = FinanceNotificationViewModel(
      FakeFinanceNotificationRepository(_notifications),
    );
    addTearDown(notifications.dispose);
    await notifications.load();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userModelProvider.overrideWith(
            (_) async => UserModel(
              name: 'Brickedup Peter',
              profilePhoto: null,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SettingsPageHeader(
                    title: 'Settings',
                    showBackButton: false,
                    notificationViewModel: notifications,
                    onNotifications: () {},
                  ),
                  Expanded(
                    child: SettingsContent(
                      profileHeader: const SettingsProfileHeader(),
                      categoryCount: 12,
                      walletCount: 3,
                      onCategories: () {},
                      onWallets: () {},
                      onEditProfile: () {},
                      onChangePassword: () {},
                      onNotifications: () {},
                      onCurrency: () {},
                      onDefaultWallet: () {},
                      onTheme: () {},
                      onLanguage: () {},
                      onScannedReceipts: () {},
                      onTerms: () {},
                      onPrivacy: () {},
                      onLogout: () {},
                      isLoggingOut: false,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: HomeBottomNavigationBar(
              selectedIndex: 3,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/settings_figma.png'),
    );
  });
}

final _notifications = List.generate(
  5,
  (index) => FinanceNotification(
    id: '$index',
    envelopeId: 'envelope-$index',
    envelopeName: 'Envelope $index',
    amount: 100,
    periodMonth: DateTime(2026, 8),
    isRead: false,
    createdAt: DateTime(2026, 8, 12),
  ),
);
