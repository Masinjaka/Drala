import 'package:budgets/features/settings/presentation/widgets/settings_content.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_icon.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_item.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the wireframe sections and invokes every destination',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final taps = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsContent(
            profileHeader: const Text('John Doe'),
            categoryCount: 12,
            walletCount: 3,
            onCategories: () => taps.add('categories'),
            onWallets: () => taps.add('wallets'),
            onEditProfile: () => taps.add('profile'),
            onChangePassword: () => taps.add('password'),
            onNotifications: () => taps.add('notifications'),
            onCurrency: () => taps.add('currency'),
            onDefaultWallet: () => taps.add('wallet'),
            onTheme: () => taps.add('theme'),
            onLanguage: () => taps.add('language'),
            onScannedReceipts: () => taps.add('receipts'),
            onTerms: () => taps.add('terms'),
            onPrivacy: () => taps.add('privacy'),
            onLogout: () => taps.add('logout'),
            isLoggingOut: false,
            appVersion: '2.0.2',
          ),
        ),
      ),
    );

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Wallets'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Zone de danger'), findsNothing);
    expect(find.text('Version 2.0.2'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(SettingsSummaryCard), findsNWidgets(2));
    expect(find.byType(SettingsMenuIcon), findsNWidgets(10));
    expect(
      tester
          .widget<SettingsMenuItem>(
            find.ancestor(
              of: find.text('Language'),
              matching: find.byType(SettingsMenuItem),
            ),
          )
          .iconAsset,
      'assets/settings/language.svg',
    );
    expect(
      tester
          .widget<SettingsMenuItem>(
            find.ancestor(
              of: find.text('Scanned receipts'),
              matching: find.byType(SettingsMenuItem),
            ),
          )
          .iconAsset,
      'assets/settings/scanned_receipts.svg',
    );

    for (final label in [
      'Categories',
      'Wallets',
      'Edit profile',
      'Change password',
      'Notification',
      'Currency',
      'Set default wallet',
      'Theme',
      'Language',
      'Scanned receipts',
      'Terms of service',
      'Privacy policy',
      'Log out',
    ]) {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pump();
    }

    expect(
      taps,
      [
        'categories',
        'wallets',
        'profile',
        'password',
        'notifications',
        'currency',
        'wallet',
        'theme',
        'language',
        'receipts',
        'terms',
        'privacy',
        'logout',
      ],
    );
  });
}
