# Traktor Touch FX (v0.1, untested build)

A second-screen touch window for Traktor Pro 4 with full control of all four FX units,
including Pattern Player mode. Traktor draws the window itself; no bridge, MIDI or extra hardware.

## Install
1. Quit Traktor.
2. Windows: double-click `install/install-windows.cmd` (asks for admin rights).
   macOS: double-click `install/install-mac.command` (asks for your password if needed).
3. Start Traktor, then Preferences > Controller Manager > Add... > Traktor > Kontrol D2.
   No D2 hardware is needed. Use the D2, not the S8: the S8 has two screens and would open two windows.
4. The "Traktor Touch FX" window opens. With a second monitor it goes fullscreen there;
   the round FS button in the centre toggles fullscreen.
5. For FX 3 and FX 4: Preferences > Effects > 4 FX Units.

Uninstall: `install/uninstall-windows.cmd`, or `install/install-mac.command uninstall` in Terminal.
A Traktor update removes the mod; run the installer again.

## What the installer changes
- Adds `qml/Screens/TraktorTouch/` (our files).
- Adds one `Loader` line at the end of `qml/Screens/S8/Views/Screen.qml`
  (original saved next to it as `Screen.qml.traktortouch-backup`).

## Each FX panel
- GROUP / SINGLE / PATTERN: unit mode. SEND / INSERT / POST FADER: tap to cycle routing.
- SNAP: store snapshot. A B C D: assign the unit to a deck.
- TOUCH: touching a fader switches that effect on, releasing switches it off.
- Group: dry/wet + three slots (tap the name to pick an effect, fader, on button).
- Single: tap the name to pick the effect; ON, three parameters and three buttons.
- Pattern Player: tap the kit name to pick a kit; volume, sound and the other two parameters
  (stepped ones get + / - buttons), 16 step buttons, CLEAR.

## To check on first run
- Step buttons: Traktor shows step state to QML, but writing it from a screen is unconfirmed.
- CLEAR and SNAP are trigger-type controls; confirm they fire.
- Two faders at once on your touch monitor (Windows should; macOS depends on the monitor driver).
- If the window does not appear, Traktor's log will name the QML line at fault.
