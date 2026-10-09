import 'dart:math' as math;

import 'package:budgets/features/ads/data/admob_configuration.dart';
import 'package:budgets/features/ads/data/admob_consent_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeNativeAd extends StatefulWidget {
  const HomeNativeAd({super.key});

  @override
  State<HomeNativeAd> createState() => _HomeNativeAdState();
}

class _HomeNativeAdState extends State<HomeNativeAd> {
  NativeAd? _ad;
  bool _loaded = false;
  Brightness? _brightness;
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scheme = Theme.of(context).colorScheme;
    if (_brightness == scheme.brightness) return;
    _brightness = scheme.brightness;
    _ad?.dispose();
    _ad = null;
    _loaded = false;
    final generation = ++_generation;
    final unitId = AdMobConfiguration.nativeUnitId;
    if (unitId != null) _load(unitId, scheme, generation);
  }

  Future<void> _load(String unitId, ColorScheme scheme, int generation) async {
    if (!await AdMobConsentService.canLoadAds() ||
        !mounted ||
        generation != _generation) {
      return;
    }
    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: scheme.surfaceContainer,
        cornerRadius: 10,
        primaryTextStyle: NativeTemplateTextStyle(textColor: scheme.onSurface),
        secondaryTextStyle:
            NativeTemplateTextStyle(textColor: scheme.onSurfaceVariant),
        tertiaryTextStyle:
            NativeTemplateTextStyle(textColor: scheme.onSurfaceVariant),
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: scheme.onPrimary,
          backgroundColor: scheme.primary,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted || generation != _generation) {
            loadedAd.dispose();
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (failedAd, _) {
          failedAd.dispose();
          if (mounted && generation == _generation) {
            setState(() => _ad = null);
          }
        },
      ),
    );
    _ad = ad;
    try {
      await ad.load();
    } catch (_) {
      ad.dispose();
      if (mounted && generation == _generation) setState(() => _ad = null);
    }
  }

  @override
  void dispose() {
    _generation++;
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Padding(
      key: const Key('home-native-ad-area'),
      padding: const EdgeInsets.fromLTRB(30, 10, 28, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // The iOS template's media is 16:9. Allow room for its visible
          // details while keeping Google's 320-point medium-template minimum.
          final height = Theme.of(context).platform == TargetPlatform.iOS
              ? math.max(320.0, constraints.maxWidth * 9 / 16 + 135)
              : 350.0;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(height: height, child: AdWidget(ad: _ad!)),
          );
        },
      ),
    );
  }
}
