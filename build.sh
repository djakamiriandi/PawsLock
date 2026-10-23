#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🐾 [1/4] Building PawsLock in release mode..."
swift build -c release

APP_BUNDLE="PawsLock.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

echo "🐾 [2/4] Constructing $APP_BUNDLE bundle..."
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS"
mkdir -p "$RESOURCES"

cp "$(swift build -c release --show-bin-path)/PawsLock" "$MACOS/PawsLock"
cp "Info.plist" "$CONTENTS/Info.plist"
if [ -d "Resources" ]; then
    xattr -cr Resources 2>/dev/null || true
    cp -R Resources/* "$RESOURCES/"
fi
chmod +x "$MACOS/PawsLock"

echo "🐾 [3/4] Code-signing PawsLock.app with ad-hoc signature..."
xattr -cr "$APP_BUNDLE" 2>/dev/null || true
codesign --force --deep --sign - "$APP_BUNDLE"

echo "🐾 [4/4] Build complete!"
echo "App created at: $SCRIPT_DIR/$APP_BUNDLE"
