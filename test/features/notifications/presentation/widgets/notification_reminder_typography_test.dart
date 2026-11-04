import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_typography.dart';
import 'package:budgets/features/notifications/presentation/widgets/notification_reminder_time_tile.dart';
import 'package:budgets/features/settings/presentation/widgets/settings_menu_group.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('French reminder caption stays muted and fits large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.5)),
        child: child!,
      ),
      home: Scaffold(
        body: SettingsMenuGroup(items: [
          NotificationReminderTimeTile(
            time: const TimeOfDay(hour: 10, minute: 0),
            onTap: () {},
          ),
        ]),
      ),
    ));
    final caption =
        tester.widget<Text>(find.text('Heure d’envoi du rappel quotidien'));
    expect(caption.style?.fontSize, AppTypography.supporting);
    expect(caption.style?.fontWeight, FontWeight.normal);
    expect(
        caption.style?.color, AppTheme.lightTheme.colorScheme.onSurfaceVariant);
    expect(tester.takeException(), isNull);
  });
}
