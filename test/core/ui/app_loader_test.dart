import 'package:budgets/core/paths.dart';
import 'package:budgets/core/ui/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

void main() {
  for (final path in [AppPaths.loaderLight, AppPaths.loaderDark]) {
    test('decodes $path as a dotLottie archive', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final bytes = await rootBundle.load(path);
      final composition =
          await AppLoader.decodeDotLottie(bytes.buffer.asUint8List());
      expect(composition, isNotNull);
      expect(composition!.duration, greaterThan(Duration.zero));
    });
  }

  for (final brightness in Brightness.values) {
    testWidgets('picks the ${brightness.name} animation', (tester) async {
      await tester.pumpWidget(MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: const Center(child: AppLoader())));
      final lottie = tester.widget<LottieBuilder>(find.byType(LottieBuilder));
      final asset = (lottie.lottie as AssetLottie).assetName;
      expect(
          asset,
          brightness == Brightness.dark
              ? AppPaths.loaderDark
              : AppPaths.loaderLight);
    });
  }
}
