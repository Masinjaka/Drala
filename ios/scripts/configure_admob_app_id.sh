#!/bin/bash
set -euo pipefail

# Flutter passes each --dart-define as a base64 entry in DART_DEFINES.
app_id=''
IFS=',' read -r -a encoded_defines <<< "${DART_DEFINES:-}"
for encoded in "${encoded_defines[@]}"; do
  decoded="$(printf '%s' "$encoded" | base64 -D 2>/dev/null || true)"
  if [[ "$decoded" == ADMOB_IOS_APP_ID=* ]]; then
    app_id="${decoded#ADMOB_IOS_APP_ID=}"
    break
  fi
done

if [[ -z "$app_id" ]]; then
  exit 0
fi
if [[ ! "$app_id" =~ ^ca-app-pub-[0-9]{16}~[0-9]{10}$ ]]; then
  echo 'error: ADMOB_IOS_APP_ID is not a valid AdMob app ID.' >&2
  exit 1
fi

plist="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :GADApplicationIdentifier $app_id" "$plist"
