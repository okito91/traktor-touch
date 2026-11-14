import QtQuick 2.0
import "."

// One-finger input surface. Reports press / drag / release in local coordinates.
// Touch mode uses MultiPointTouchArea (several surfaces can be held at once);
// mouse mode uses MouseArea as a fallback for screens that only send mouse events.
Item {
  id: surface

  property bool held: false

  signal down(real px, real py)
  signal drag(real px, real py)
  signal up()

  function begin(px, py) { held = true; down(px, py) }
  function end()         { if (held) { held = false; up() } }

  MultiPointTouchArea {
    anchors.fill: parent
    enabled: !TouchRegistry.mouseInput
    maximumTouchPoints: 1
    touchPoints: [ TouchPoint { id: tp } ]
    onPressed:  surface.begin(tp.x, tp.y)
    onUpdated:  surface.drag(tp.x, tp.y)
    onReleased: surface.end()
    onCanceled: surface.end()
  }

  MouseArea {
    anchors.fill: parent
    enabled: TouchRegistry.mouseInput
    preventStealing: true
    onPressed:         function(mouse) { surface.begin(mouse.x, mouse.y) }
    onPositionChanged: function(mouse) { if (pressed) surface.drag(mouse.x, mouse.y) }
    onReleased:        function(mouse) { surface.end() }
    onCanceled:        surface.end()
  }
}
