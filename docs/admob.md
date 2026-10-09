# AdMob native ad setup

The home screen shows an Advanced Native ad after the last transaction, including
when more transactions are loaded. The area is removed when an ad is unavailable.
The medium native template reserves a full-size
media view for video and sizes its iOS container to the visible template,
scaling with the available width. Android uses the template's 350 dp height.
The template follows the app's light and
dark surface colors. Consent is checked before a request, and Settings exposes
ad privacy choices when Google's consent SDK requires that entry.

Supply the following `--dart-define` values in the launch configuration or
Flutter build command for each supported platform:

| Define | Value |
| --- | --- |
| `ADMOB_ANDROID_APP_ID` | Android AdMob **app** ID (`ca-app-pub-…~…`) |
| `ADMOB_ANDROID_NATIVE_AD_UNIT_ID` | Android Advanced Native **ad unit** ID (`ca-app-pub-…/…`) |
| `ADMOB_IOS_APP_ID` | iOS AdMob **app** ID (`ca-app-pub-…~…`) |
| `ADMOB_IOS_NATIVE_AD_UNIT_ID` | iOS Advanced Native **ad unit** ID (`ca-app-pub-…/…`) |

`.vscode/launch.json` uses Google's native test IDs in the debug and profile
configurations. Replace them with your own IDs before distributing an app with
ads. The release configuration intentionally has no ad IDs; add your production
defines there or pass them to the release build command. If either app ID or ad
unit ID for the running platform is missing, the app makes no ad request.

The Android build copies the app ID into the manifest. The iOS build writes it
to the built app's `Info.plist`. Both use Google's sample app ID when no define
is supplied, so a build without ads remains launchable. Configure the privacy
message in the AdMob console for each production app ID before serving ads.

Run the native ad smoke test on an iOS simulator with Google's test IDs:

```sh
fvm flutter test integration_test/admob_native_test.dart -d <ios-device-id> \
  --dart-define=ADMOB_IOS_APP_ID=ca-app-pub-3940256099942544~1458002511 \
  --dart-define=ADMOB_IOS_NATIVE_AD_UNIT_ID=ca-app-pub-3940256099942544/3986624511
```
