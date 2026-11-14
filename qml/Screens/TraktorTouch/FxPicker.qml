import QtQuick 2.0

// Full-window list for choosing an effect or a drum kit.
Rectangle {
  id: picker

  property string title: ""
  property var    prop: null           // AppProperty with valuesDescription
  readonly property var names: (prop && prop.valuesDescription) ? prop.valuesDescription : []

  function open(t, p) { title = t; prop = p; visible = true }
  function close()    { visible = false; prop = null }

  visible: false
  color: "#f0090a0b"

  MultiPointTouchArea { anchors.fill: parent }   // swallow touches behind the picker

  Text {
    anchors { left: parent.left; top: parent.top; leftMargin: 30; topMargin: 22 }
    text: picker.title
    color: "#ffffff"
    font.pixelSize: 34
    font.bold: true
  }

  TButton {
    anchors { right: parent.right; top: parent.top; rightMargin: 30; topMargin: 14 }
    width: 200; height: 64
    label: "CLOSE"
    onPressed: picker.close()
  }

  GridView {
    id: grid
    anchors { fill: parent; topMargin: 96; leftMargin: 30; rightMargin: 14; bottomMargin: 20 }
    clip: true
    cellWidth: Math.floor(width / 6)
    cellHeight: 104
    model: picker.names

    delegate: Item {
      width: grid.cellWidth
      height: grid.cellHeight

      Rectangle {
        anchors { fill: parent; rightMargin: 14; bottomMargin: 14 }
        radius: 8
        readonly property bool current: picker.prop ? (picker.prop.value == index) : false
        color: current ? "#ff8a1f" : "#26282c"
        border.width: 2
        border.color: current ? "#ffb060" : "#3a3d43"

        Text {
          anchors.fill: parent
          anchors.margins: 8
          text: modelData
          color: parent.current ? "#101010" : "#e6e6e6"
          font.pixelSize: 24
          font.bold: true
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          wrapMode: Text.WordWrap
          elide: Text.ElideRight
        }

        // MouseArea (not a touch area) so the list can still be scrolled by dragging
        MouseArea {
          anchors.fill: parent
          onClicked: { if (picker.prop) picker.prop.value = index; picker.close() }
        }
      }
    }
  }
}
