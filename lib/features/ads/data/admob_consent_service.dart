import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobConsentService {
  const AdMobConsentService._();

  static Future<bool>? _request;

  static Future<bool> canLoadAds() => _request ??= _requestConsent();

  static Future<bool> _requestConsent() async {
    try {
      final update = Completer<bool>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () => update.complete(true),
        (_) => update.complete(false),
      );
      if (await update.future) {
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
      }
      if (!await ConsentInformation.instance.canRequestAds()) return false;
      await MobileAds.instance.initialize();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> get privacyOptionsRequired async {
    await canLoadAds();
    try {
      return await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  static Future<void> showPrivacyOptions() =>
      ConsentForm.showPrivacyOptionsForm((_) {});
}
