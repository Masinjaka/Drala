import 'dart:ui' as ui;
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/home/presentation/pages/wallets_page.dart';
import 'package:budgets/features/home/presentation/widgets/wallet_overview_card.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
    testWidgets('wallet cards fade out behind the title in ${theme.brightness}',
        (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 60);
      addTearDown(tester.view.reset);
      final capture = GlobalKey();
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepaintBoundary(
            key: capture,
            child: WalletsPage(
              wallets: [
                for (var i = 0; i < 10; i++)
                  WalletSummary(
                      id: '$i',
                      name: 'Wallet $i',
                      balance: 100,
                      currencyCode: 'MGA',
                      iconKey: 'cash',
                      isDefault: i == 0)
              ],
              onAddWallet: (_) async {},
              onUpdateWallet: (_, __) async {},
              onDeleteWallet: (_) async {},
            )),
      ));
      await tester.pumpAndSettle();
      final title = tester.getRect(find.text('Wallets'));
      await tester.drag(find.byType(GridView), const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.text('Wallets')), title);
      final card = tester.getRect(find.byType(WalletOverviewCard).first);
      final sample = Offset(card.right - 16, title.center.dy);
      expect(card.contains(sample), isTrue);
      expect(find.byType(BackdropFilter), findsNothing);
      final boundary =
          capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final pixels = await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1);
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        image.dispose();
        return data!;
      });
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final background = scaffold.backgroundColor!;
      final index = (sample.dy.floor() * 430 + sample.dx.floor()) * 4;
      expect(pixels!.getUint8(index), closeTo(background.r * 255, 1));
      expect(pixels.getUint8(index + 1), closeTo(background.g * 255, 1));
      expect(pixels.getUint8(index + 2), closeTo(background.b * 255, 1));
      expect(tester.takeException(), isNull);
    });
  }
}
