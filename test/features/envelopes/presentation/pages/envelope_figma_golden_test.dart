import '../../../../support/soft_shadow_test_binding.dart';
import '../../../../support/load_category_icon_font.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/features/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/pages/envelope_page.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_progress.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/load_app_fonts.dart';

void main() {
  SoftShadowTestBinding();
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await loadCategoryIconFont();
    await loadAppFonts();
    await (FontLoader('MaterialIcons')
          ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf')))
        .load();
  });
  for (final dark in [false, true]) {
    testWidgets('matches the redesigned envelope frame dark=$dark',
        (tester) async {
      _setFigmaViewport(tester);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
              builder: (context) => Scaffold(
                    backgroundColor: AppEnvelopeTheme.background(context),
                    body: EnvelopePage(
                        showBackButton: false,
                        repository: _EnvelopeRepository(),
                        initialMonth: DateTime(2026, 9)),
                    bottomNavigationBar: HomeBottomNavigationBar(
                        selectedIndex: 2, onSelected: (_) {}),
                  )),
        ),
      );
      await tester.pumpAndSettle();
      // Coordinates measured from ENVELOPE.jpg at its native 412 × 917 size.
      expect(tester.getRect(find.byKey(const Key('envelope-pick-month'))),
          const Rect.fromLTWH(252, 33, 90, 46));
      expect(tester.getRect(find.byKey(const Key('month-carousel'))),
          const Rect.fromLTWH(69, 113, 281, 50));
      expect(
          tester.getRect(find.byKey(const Key('envelope-card-surface')).first),
          const Rect.fromLTWH(15, 209, 382, 112));
      expect(tester.getRect(find.byType(EnvelopeProgress).first),
          const Rect.fromLTWH(30, 298, 352, 5));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
            dark ? 'goldens/envelope-dark.png' : 'goldens/envelope_figma.png'),
      );
    });
  }
}

void _setFigmaViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(412, 917);
  tester.view.padding = const FakeViewPadding(top: 24);
  tester.view.viewPadding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.reset);
}

class _EnvelopeRepository implements EnvelopeRepository {
  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) async {
    const names = [
      ('Rainy days', 'rain'),
      ('Food & drinks', 'rain'),
      ('Rainy days', 'rain'),
      ('Rainy days', 'rain'),
    ];
    return List.generate(
      names.length,
      (index) => Envelope(
        id: '$index',
        name: names[index].$1,
        categoryId: '$index',
        categoryName: names[index].$1,
        emoji: '',
        iconKey: names[index].$2,
        color: index == 1 ? 'FF343434' : 'FFFFFFFF',
        amount: 350000,
        spent: [227500, 70000, 280000, 350000][index],
        currencyCode: 'MGA',
      ),
    );
  }

  @override
  Future<List<EnvelopeCategory>> expenseCategories() async => const [];
  @override
  Future<List<WalletSummary>> wallets() async => const [];
  @override
  Future<void> addEnvelope({
    required String name,
    required String categoryId,
    required int amount,
    required DateTime month,
    String? walletId,
    bool repeatsMonthly = false,
  }) async {}
  @override
  Future<void> updateEnvelope(
      {required String id,
      required String name,
      required String categoryId,
      required int amount,
      required bool repeatsMonthly}) async {}

  @override
  Future<void> deleteEnvelope(String id) async {}
}
