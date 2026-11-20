// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/amount_visibility_controller.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import 'demo_ai_repository.dart';
import 'demo_seed.dart';
import 'store_app.dart';

/// Saves one PNG capture under [name].
typedef SaveCapture = Future<void> Function(String name, Uint8List png);

final storeToday = DateTime(2026, 11, 19, 10);
const _root = Key('store-root');

/// The same navigation, on the host test engine or on a real device.
class StoreCaptureFlow {
  StoreCaptureFlow(this.tester, this.save, {required this.pixelRatio});
  final WidgetTester tester;
  final SaveCapture save;
  final double pixelRatio;

  Future<void> settle() async {
    for (var i = 0; i < 8; i++) {
      await tester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 40)));
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  Future<void> shot(String name) async {
    await settle();
    final boundary =
        tester.renderObject<RenderRepaintBoundary>(find.byKey(_root));
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await save(name, bytes!.buffer.asUint8List());
    });
  }

  Future<void> tap(Finder finder) async {
    await tester.tap(finder.first);
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> openTab(int index) => tap(find
      .descendant(
          of: find.byKey(const Key('home-navigation-surface')),
          matching: find.byWidgetPredicate((w) => w is Icon || w is FaIcon))
      .at(index));

  Future<GuestSession> _guest() async {
    SharedPreferences.setMockInitialValues({});
    final guest =
        await GuestSession.load(GuestDatabase(NativeDatabase.memory()));
    await seedDemoData(guest, storeToday);
    return guest;
  }

  Future<GuestSession> guest() => _guest();

  Future<void> pumpApp(GuestSession guest, AmountVisibilityController v,
          {bool signedIn = false, CurrencyState? currency}) =>
      _pump(guest, v, signedIn: signedIn, currency: currency);

  Future<void> _pump(GuestSession guest, AmountVisibilityController v,
      {bool dark = false,
      bool signedIn = false,
      CurrencyState? currency}) async {
    await tester.pumpWidget(RepaintBoundary(
        key: _root,
        child: storeApp(
            guest: guest,
            today: storeToday,
            visibility: v,
            dark: dark,
            asGuest: !signedIn,
            currency: currency,
            aiRepository: signedIn ? DemoAiEntryRepository(guest) : null)));
  }

  Future<void> guestScreens(AmountVisibilityController v) async {
    await _pump(await _guest(), v);
    await shot('home');
    for (final (i, name) in [
      (1, 'activities'),
      (2, 'envelopes'),
      (3, 'stats')
    ]) {
      await openTab(i);
      await shot(name);
    }
    await tap(find.text('Les catégories'));
    await shot('stats-categories');
    await openTab(0);
    await settle();
    await tap(find.byKey(const Key('notification-inbox-button')));
    await shot('notifications');
  }

  Future<void> darkScreens(AmountVisibilityController v) async {
    await _pump(await _guest(), v, dark: true);
    await shot('home-dark');
    await openTab(4);
    await shot('settings-dark');
    await openTab(2);
    await shot('envelopes-dark');
    await openTab(3);
    await tap(find.text('Les catégories'));
    await shot('stats-dark');
  }

  Future<void> aiScreens(AmountVisibilityController v) async {
    await _pump(await _guest(), v, signedIn: true);
    await shot('home-signed');
    await openTab(1);
    await shot('ai-idle');
    await tap(find.byIcon(Icons.add_rounded));
    await shot('receipt-sheet');
    await tester.tapAt(const Offset(200, 160));
    await settle();
    await tester.enterText(find.byType(TextField).first,
        'Paiement client 450 000 et déjeuner 25 000');
    await shot('ai-typed');
    FocusManager.instance.primaryFocus?.unfocus();
    await shot('ai-typed-clean');
  }
}
