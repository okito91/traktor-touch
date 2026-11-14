import QtQuick 2.0

// Vertical touch fader bound to a Traktor AppProperty (value 0..1). Absolute position on touch.
Item {
  id: fader

  property var    prop: null            // AppProperty
  property color  fillColor: "#ff8a1f"
  property bool   dimmed: false
  property bool   touched: false
  readonly property real value: (prop && prop.value !== undefined) ? Math.max(0, Math.min(1, prop.value)) : 0

  signal touchStart()
  signal touchEnd()

  opacity: dimmed ? 0.3 : 1.0

  function setFromY(y) {
    if (!prop) return;
    var pad = 14;
    var v = 1 - (y - pad) / (height - 2 * pad);
    prop.value = Math.max(0, Math.min(1, v));
  }

  Rectangle {
    id: track
    anchors.fill: parent
    radius: 8
    color: "#17181b"
    border.width: 2
    border.color: fader.touched ? fader.fillColor : "#3a3d43"

    Rectangle {
      anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 4 }
      height: Math.max(0, (parent.height - 8) * fader.value)
      radius: 5
      color: fader.fillColor
      opacity: 0.55
    }

    // handle
    Rectangle {
      anchors { left: parent.left; right: parent.right; margins: 4 }
      height: 12
      radius: 4
      y: 14 + (1 - fader.value) * (parent.height - 28) - 6
      color: "#f2f2f2"
    }
  }

  MultiPointTouchArea {
    anchors.fill: parent
    maximumTouchPoints: 1
    enabled: !fader.dimmed
    onPressed:  function(touchPoints) { fader.touched = true; fader.setFromY(touchPoints[0].y); fader.touchStart() }
    onUpdated:  function(touchPoints) { fader.setFromY(touchPoints[0].y) }
    onReleased: function(touchPoints) { fader.touched = false; fader.touchEnd() }
    onCanceled: function(touchPoints) { fader.touched = false; fader.touchEnd() }
  }
}
