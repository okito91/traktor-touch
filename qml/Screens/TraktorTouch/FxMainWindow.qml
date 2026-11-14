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

  // Go fullscreen on the second monitor (the one that is not the primary at 0,0).
  // With a single monitor the window stays a normal window.
  function findSecondScreen() {
    var screens = Qt.application.screens;
    if (!screens || screens.length < 2) return null;
    for (var i = 0; i < screens.length; i++) {
      if (screens[i].virtualX != 0 || screens[i].virtualY != 0) return screens[i];
    }
    return screens[screens.length - 1];
  }

  function goToSecondScreen() {
    var s = findSecondScreen();
    if (!s) return;
    try { win.visibility = Window.Windowed; } catch (e) {}
    try { win.screen = s; } catch (e) { console.log("TraktorTouch: screen assign failed: " + e); }
    try {
      win.x = s.virtualX;
      win.y = s.virtualY;
      win.width = s.width;
      win.height = s.height;
    } catch (e) { console.log("TraktorTouch: move failed: " + e); }
    try { win.showFullScreen(); } catch (e) { win.visibility = Window.FullScreen; }
  }

  // wait until Traktor has finished opening its own window, then place ours
  Timer { id: placeTimer; interval: 1200; onTriggered: win.goToSecondScreen() }
  Component.onCompleted: placeTimer.start()

  // a monitor was plugged in or removed
  Connections {
    target: Qt.application
    function onScreensChanged() { placeTimer.restart() }
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

    // centre button: fullscreen on/off (plain MouseArea).
    // Shows logo.png from this folder when it exists, otherwise the word FULL.
    Rectangle {
      anchors.centerIn: parent
      width: 68; height: 68; radius: 34
      color: "#0e0f11"; border.width: 2; border.color: "#3a3d43"

      Image {
        id: logo
        anchors { fill: parent; margins: 6 }
        source: "logo.png"
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: status == Image.Ready
      }
      Text {
        anchors.centerIn: parent
        visible: logo.status != Image.Ready
        text: "FULL"; color: "#e6e6e6"; font.pixelSize: 15; font.bold: true
      }
      MouseArea { anchors.fill: parent; onClicked: win.toggleFullScreen() }
    }

    FxPicker {
      id: picker
      anchors.fill: parent
    }
  }
}
