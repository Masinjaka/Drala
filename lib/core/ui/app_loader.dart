import 'package:budgets/core/paths.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// App-wide loading indicator: the money-count dotLottie animation,
/// switching between light and dark variants with the active theme.
class AppLoader extends StatelessWidget {
  const AppLoader({this.size = 60, this.animate = true, super.key});

  /// Inline variant for small slots (list trailing, text rows).
  const AppLoader.small({super.key})
      : size = 25,
        animate = true;

  final double size;

  /// When false the first frame is shown (e.g. while a pull is in progress).
  final bool animate;

  /// Decodes a .lottie (zip) archive, picking the animation JSON.
  static Future<LottieComposition?> decodeDotLottie(List<int> bytes) =>
      LottieComposition.decodeZip(bytes, filePicker: (files) {
        for (final file in files) {
          if (file.name.startsWith('animations/') &&
              file.name.endsWith('.json')) {
            return file;
          }
        }
        return null;
      });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Lottie.asset(
          dark ? AppPaths.loaderDark : AppPaths.loaderLight,
          key: ValueKey(dark),
          decoder: decodeDotLottie,
          width: size,
          height: size,
          fit: BoxFit.contain,
          animate: animate && !MediaQuery.disableAnimationsOf(context),
          frameRate: FrameRate.composition,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
