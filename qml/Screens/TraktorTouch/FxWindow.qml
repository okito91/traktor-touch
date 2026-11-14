import CSI 1.0
import QtQuick 2.0
import QtQuick.Window 2.15

// Traktor Touch - second-screen FX controller. Loaded from Screens/S8/Views/Screen.qml.
Window {
  id: win

  readonly property int designW: 1920
  readonly property int designH: 1080

  title: "Traktor Touch FX"
  color: "#000000"
  width: 1280
  height: 720
  visible: true

  AppProperty { id: fourUnits; path: "app.traktor.fx.4fx_units" }

  function toggleFullScreen() {
    win.visibility = (win.visibility == Window.FullScreen) ? Window.Windowed : Window.FullScreen;
  }

  // Start fullscreen on the second monitor when there is one; otherwise stay a normal window.
  Component.onCompleted: {
    try {
      var screens = Qt.application.screens;
      if (screens && screens.length > 1) {
        win.screen = screens[screens.length - 1];
        win.x = win.screen.virtualX;
        win.y = win.screen.virtualY;
        win.visibility = Window.FullScreen;
      }
    } catch (e) {
      console.log("TraktorTouch: could not move to second screen: " + e);
    }
  }

  Item {
    id: root
    width: win.designW
    height: win.designH
    transformOrigin: Item.TopLeft
    scale: Math.min(win.width / win.designW, win.height / win.designH)
    x: (win.width  - width  * scale) / 2
    y: (win.height - height * scale) / 2

    Grid {
      anchors.fill: parent
      columns: 2
      Repeater {
        model: 4
        FxUnitPanel {
          width: win.designW / 2
          height: win.designH / 2
          unit: index + 1
          unitAvailable: index < 2 || fourUnits.value == true
          onPickerRequested: function(title, prop) { picker.open(title, prop) }
        }
      }
    }

    // small fullscreen toggle in the very centre, between the four panels
    TButton {
      anchors.centerIn: parent
      width: 56; height: 56
      radius: 28
      label: "⛶"
      fontSize: 22
      onPressed: win.toggleFullScreen()
    }

    FxPicker {
      id: picker
      anchors.fill: parent
    }
  }
}
