pragma Singleton
import QtQuick 2.0

// Shared state for all Traktor Touch instances.
QtObject {
  property bool claimed: false      // true once one screen instance owns the FX window
  property bool mouseInput: false   // false = touch areas (multi-touch), true = mouse areas (fallback)
}
