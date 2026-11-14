import QtQuick 2.0
import "."

// Entry point loaded from Screens/S8/Views/Screen.qml.
// Traktor can create that screen several times; only the first instance opens the FX window.
Item {
  id: host

  property bool owner: false

  function claim() {
    if (!TouchRegistry.claimed) {
      TouchRegistry.claimed = true;
      host.owner = true;
    }
  }

  Component.onCompleted: claim()
  Component.onDestruction: { if (host.owner) TouchRegistry.claimed = false }

  // take over if the owning instance goes away
  Connections {
    target: TouchRegistry
    function onClaimedChanged() { if (!TouchRegistry.claimed && !host.owner) host.claim() }
  }

  Loader {
    active: host.owner
    source: "FxMainWindow.qml"
  }
}
