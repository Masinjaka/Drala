import 'package:flutter/foundation.dart';

class AdMobConfiguration {
  const AdMobConfiguration._();

  static const enabled = false;
  static const androidAppId = String.fromEnvironment('ADMOB_ANDROID_APP_ID');
  static const iosAppId = String.fromEnvironment('ADMOB_IOS_APP_ID');
  static const androidNativeUnitId =
      String.fromEnvironment('ADMOB_ANDROID_NATIVE_AD_UNIT_ID');
  static const iosNativeUnitId =
      String.fromEnvironment('ADMOB_IOS_NATIVE_AD_UNIT_ID');

  static String? get nativeUnitId {
    if (!enabled || kIsWeb) return null;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android =>
        androidAppId.isNotEmpty && androidNativeUnitId.isNotEmpty
            ? androidNativeUnitId
            : null,
      TargetPlatform.iOS => iosAppId.isNotEmpty && iosNativeUnitId.isNotEmpty
          ? iosNativeUnitId
          : null,
      _ => null,
    };
  }
}
