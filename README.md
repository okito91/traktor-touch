# Traktor Touch FX (v0.5)

A second-screen touch window for Traktor Pro 4 with full control of all four FX units,
including Pattern Player mode. Traktor draws the window itself; no bridge, MIDI or extra hardware.

## Install
1. Quit Traktor.
2. Windows: double-click `install/install-windows.cmd` (asks for admin rights).
   macOS: double-click `install/install-mac.command` (asks for your password if needed).
3. Start Traktor, then Preferences > Controller Manager > Add... > Traktor > Kontrol D2.
   No D2 hardware is needed. Add it once only.
4. The "Traktor Touch FX" window opens and goes fullscreen on the second monitor by itself.
   The DjLab logo button in the centre switches fullscreen off and on
   (image: `qml/Screens/TraktorTouch/logo.png`).
5. For FX 3 and FX 4: Preferences > Effects > 4 FX Units.

Uninstall: `install/uninstall-windows.cmd`, or `install/install-mac.command uninstall` in Terminal.
A Traktor update removes the mod; run the installer again.

## What the installer changes
- Adds `qml/Screens/TraktorTouch/` (our files).
- Adds one `Loader` line at the end of `qml/Screens/S8/Views/Screen.qml`.
- Adds `qml/CSI/D2/TraktorTouchBridge.qml` and one line in `qml/CSI/D2/D2.qml`
  (needed so the window can move FX knobs 1-3).
- Both originals are saved next to the files as `*.traktortouch-backup`.

## Each FX panel
- GROUP / SINGLE / PATTERN: unit mode. SEND / INSERT / POST FADER: tap to cycle routing.
- SNAP: store snapshot. A B C D: assign the unit to a deck.
- TOUCH (on by default): touching a fader switches the effect on, releasing switches it off.
  Group: each slot fader controls its own slot. Single and Pattern Player: any fader controls the unit's ON.
- Group: dry/wet + three slots (tap the name to pick an effect, fader, on button).
- Single: tap the name to pick the effect; ON, three parameters and three buttons.
- Pattern Player: tap the kit name to pick a kit; volume, sound and the other two parameters
  (stepped ones get + / - buttons), 16 step buttons, CLEAR.
  Slide one finger across the steps to paint them: the first step you touch decides on or off.

## Updating
Quit Traktor and run the installer again; it replaces the TraktorTouch folder.
