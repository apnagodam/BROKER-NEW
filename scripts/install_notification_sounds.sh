#!/usr/bin/env bash
# Copies audio assets into Android and iOS native folders so custom
# notification sounds are available to the system notification APIs.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ASSETS_DIR="$ROOT_DIR/assets/sounds"
ANDROID_RAW_DIR="$ROOT_DIR/android/app/src/main/res/raw"
IOS_RUNNER_DIR="$ROOT_DIR/ios/Runner"

echo "Assets: $ASSETS_DIR"

if [ ! -d "$ASSETS_DIR" ]; then
  echo "No assets/sounds directory found. Create and add your .wav/.mp3 files there." >&2
  exit 1
fi

mkdir -p "$ANDROID_RAW_DIR"
echo "Copying files to Android res/raw..."
for f in "$ASSETS_DIR"/*; do
  if [ -f "$f" ]; then
    filename=$(basename "$f")
    # Android resource names must be lowercase, alphanumeric and underscores
    lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_.]/_/g')
    dest="$ANDROID_RAW_DIR/${lower}"
    cp "$f" "$dest"
    echo "  -> $dest"
  fi
done

echo "Copying files to iOS Runner/ (you still need to add them to the Xcode project)" 
for f in "$ASSETS_DIR"/*; do
  if [ -f "$f" ]; then
    filename=$(basename "$f")
    dest="$IOS_RUNNER_DIR/$filename"
    cp "$f" "$dest"
    echo "  -> $dest"
  fi
done

echo "Done. For iOS: open Runner.xcworkspace, add these sound files to the Runner target (Build Phases -> Copy Bundle Resources) so the system can access them for notifications."
echo "For Android: resources were copied to android/app/src/main/res/raw. Rebuild the app."
