# Execution report — Drala Play Store screenshots (fr, android-phone)

## What ran
- `inspect-project`, `extract-design-tokens`, `analyze-reference` (collage of 16 sets; panels were read by eye because the auto-split doesn't apply).
- Captures: `fvm flutter test integration_test/store_screenshots_test.dart -d emulator-5554` on the AVD `Drala_Store_Phone` (created on the installed android-35 image; the Pixel_10_Pro image isn't installed). The test seeds fictional demo data into an in-memory guest database, navigates the real `ChatHomePage`, and streams each PNG to the log as base64 `STOREPNG <name> <chunk>` lines, because the test run uninstalls the app. The lines were then decoded into `captures/android/fr/`.
- `render-screenshots`, `generate-contact-sheet`, `validate-exports`: COMPLIANT, 0 errors, 0 warnings.

## Verified visually
All 14 captures, the contact sheet, and the thumbnails, over 3 render iterations.

## Known limits
- AI entry and receipt scanning need a signed-in account. Those captures use the signed-in layout over the same local demo data. The AI request itself is not run.
- The typed AI capture has a dimmed list (focused composer), so panel 2 shows the clean Activities screen with the composer as an enlarged real crop.
- Notification timestamps show when the capture ran (20 nov. 2026).
- No tablet set and no English set.
