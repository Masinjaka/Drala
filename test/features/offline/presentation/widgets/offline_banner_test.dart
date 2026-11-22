import 'dart:io';
import 'package:budgets/core/theme.dart';
import 'package:budgets/features/offline/data/services/offline_connectivity.dart';
import 'package:budgets/features/offline/presentation/widgets/offline_banner.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late OfflineConnectivity connectivity;
  setUp(() => connectivity = OfflineConnectivity());
  tearDown(() => connectivity.dispose());

  final banner = find.byKey(const Key('offline-banner'));
  final dismiss = find.byKey(const Key('offline-banner-dismiss'));
  const lookupFailure = SocketException('Failed host lookup');

  Future<TextEditingController> pumpApp(WidgetTester tester) async {
    final text = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          OfflineBanner(connectivity: connectivity, child: child!),
      home: Scaffold(
        appBar: AppBar(title: const Text('Header')),
        body: TextField(controller: text),
      ),
    ));
    return text;
  }

  testWidgets('stays hidden while online', (tester) async {
    await pumpApp(tester);
    expect(banner, findsNothing);
  });

  testWidgets('shows above the page header while offline', (tester) async {
    await pumpApp(tester);
    connectivity.failed(lookupFailure);
    await tester.pump();

    expect(find.text('You are currently offline'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    expect(tester.getBottomLeft(banner).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byType(AppBar)).dy));
  });

  testWidgets('dismisses until the next time the connection drops',
      (tester) async {
    await pumpApp(tester);
    connectivity.failed(lookupFailure);
    await tester.pump();

    await tester.tap(dismiss);
    await tester.pump();
    expect(banner, findsNothing);

    connectivity.failed(lookupFailure);
    await tester.pump();
    expect(banner, findsNothing, reason: 'still the same outage');

    connectivity.recovered();
    await tester.pump();
    connectivity.failed(lookupFailure);
    await tester.pump();
    expect(banner, findsOneWidget);
  });

  testWidgets('keeps page state when it appears and disappears',
      (tester) async {
    final text = await pumpApp(tester);
    await tester.enterText(find.byType(TextField), 'Unfinished entry');
    final field = tester.element(find.byType(TextField));

    connectivity.failed(lookupFailure);
    await tester.pump();
    connectivity.recovered();
    await tester.pump();

    expect(text.text, 'Unfinished entry');
    expect(tester.element(find.byType(TextField)), same(field));
  });
}
