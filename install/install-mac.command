#!/bin/bash
# Traktor Touch FX - installer for macOS. Double-click, or run with "uninstall" to remove.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
APP="$(ls -d "/Applications/Native Instruments/Traktor Pro 4"*/Traktor*.app 2>/dev/null | head -1)"
QML="$APP/Contents/Resources/qml"
if [ -z "$APP" ] || [ ! -d "$QML" ]; then echo "Traktor Pro 4 qml folder not found."; exit 1; fi
if pgrep -x "Traktor Pro 4" >/dev/null 2>&1; then echo "Please quit Traktor first."; exit 1; fi

SCREEN="$QML/Screens/S8/Views/Screen.qml"
BACKUP="$SCREEN.traktortouch-backup"
DEST="$QML/Screens/TraktorTouch"
D2="$QML/CSI/D2/D2.qml"
D2BACKUP="$D2.traktortouch-backup"
BRIDGE="$QML/CSI/D2/TraktorTouchBridge.qml"
SUDO=""; [ -w "$QML/Screens" ] || SUDO="sudo"

if [ "$1" = "uninstall" ]; then
  [ -f "$BACKUP" ] && $SUDO cp "$BACKUP" "$SCREEN" && $SUDO rm "$BACKUP"
  $SUDO rm -rf "$DEST"
  [ -f "$D2BACKUP" ] && $SUDO cp "$D2BACKUP" "$D2" && $SUDO rm "$D2BACKUP"
  $SUDO rm -f "$BRIDGE"
  echo "Traktor Touch FX removed."; exit 0
fi

$SUDO rm -rf "$DEST"
$SUDO cp -R "$HERE/../qml/Screens/TraktorTouch" "$DEST"

if grep -q "TRAKTOR-TOUCH" "$SCREEN"; then
  echo "Screen.qml already patched - files updated."
else
  [ -f "$BACKUP" ] || $SUDO cp "$SCREEN" "$BACKUP"
  $SUDO perl -0pi -e 's/\}(\s*)\z/\r\n  \/\/ TRAKTOR-TOUCH (second-screen FX window)\r\n  Loader { source: "..\/..\/TraktorTouch\/FxWindow.qml" }\r\n}$1/' "$SCREEN"
  grep -q "TRAKTOR-TOUCH" "$SCREEN" || { echo "Patch failed - Screen.qml unchanged."; exit 1; }
fi
# knob bridge for the D2 mapping
$SUDO cp "$HERE/../qml/CSI/D2/TraktorTouchBridge.qml" "$BRIDGE"
if ! grep -q "TRAKTOR-TOUCH" "$D2"; then
  [ -f "$D2BACKUP" ] || $SUDO cp "$D2" "$D2BACKUP"
  $SUDO perl -0pi -e 's/(Mapping\s*\{)/$1\r\n  TraktorTouchBridge { name: "traktor_touch_bridge" } \/\/ TRAKTOR-TOUCH/' "$D2"
  grep -q "TRAKTOR-TOUCH" "$D2" || { echo "D2.qml patch failed."; exit 1; }
fi
echo "Installed into $QML"
echo "Now start Traktor and add: Preferences > Controller Manager > Add... > Traktor > Kontrol D2"
