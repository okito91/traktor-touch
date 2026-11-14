import QtQuick 2.0

// Touch button.
Rectangle {
  id: btn

  property string label: ""
  property bool   lit: false
  property color  litColor: "#ff8a1f"
  property color  idleColor: "#26282c"
  property int    fontSize: 22
  property bool   dimmed: false
  property bool   down: false

  signal pressed()
  signal released()

  radius: 8
  color: lit ? litColor : (down ? "#44484f" : idleColor)
  border.width: 2
  border.color: lit ? Qt.lighter(litColor, 1.3) : "#3a3d43"
  opacity: dimmed ? 0.35 : 1.0

  Text {
    anchors.fill: parent
    anchors.margins: 6
    text: btn.label
    color: btn.lit ? "#101010" : "#e6e6e6"
    font.pixelSize: btn.fontSize
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    elide: Text.ElideRight
  }

  TouchSurface {
    anchors.fill: parent
    enabled: !btn.dimmed
    onDown: function(px, py) { btn.down = true; btn.pressed() }
    onUp: { btn.down = false; btn.released() }
  }
}
