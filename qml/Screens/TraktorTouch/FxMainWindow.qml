import CSI 1.0
import QtQuick 2.0
import QtQuick.Window 2.15
import "."

// Traktor Touch - second-screen FX controller window (created once by FxWindow.qml).
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

    // centre controls: fullscreen toggle and input mode. Plain MouseAreas so they work in either input mode.
    Column {
      anchors.centerIn: parent
      spacing: 6

      Rectangle {
        width: 64; height: 40; radius: 8
        color: "#26282c"; border.width: 2; border.color: "#3a3d43"
        Text { anchors.centerIn: parent; text: "FULL"; color: "#e6e6e6"; font.pixelSize: 15; font.bold: true }
        MouseArea { anchors.fill: parent; onClicked: win.toggleFullScreen() }
      }

      Rectangle {
        width: 64; height: 40; radius: 8
        color: TouchRegistry.mouseInput ? "#4aa3ff" : "#26282c"; border.width: 2; border.color: "#3a3d43"
        Text { anchors.centerIn: parent; text: TouchRegistry.mouseInput ? "MOUSE" : "TOUCH"; color: TouchRegistry.mouseInput ? "#101010" : "#e6e6e6"; font.pixelSize: 13; font.bold: true }
        MouseArea { anchors.fill: parent; onClicked: TouchRegistry.mouseInput = !TouchRegistry.mouseInput }
      }
    }

    FxPicker {
      id: picker
      anchors.fill: parent
    }
  }
}
