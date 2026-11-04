import 'package:flutter/services.dart';

Future<void> loadCategoryIconFont() async {
  await (FontLoader('packages/ionicons/Ionicons')
        ..addFont(
            rootBundle.load('packages/ionicons/assets/fonts/Ionicons.ttf')))
      .load();
}
