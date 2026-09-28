import 'package:budgets/features/home/presentation/widgets/drawer_menu_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('wallet drawer item invokes its callback', (tester) async {
    var walletTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DrawerMenuSection(
            onEnvelopePressed: () {},
            onStatsPressed: () {},
            onWalletsPressed: () => walletTaps++,
            onCategoriesPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Wallets'), findsOneWidget);
    await tester.tap(find.byKey(const Key('drawer-wallets-button')));

    expect(walletTaps, 1);
  });
}
