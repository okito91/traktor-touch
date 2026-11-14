import QtQuick 2.0

// One control column: top label/picker button, fader with value text, bottom button.
Item {
  id: col

  property string topLabel: ""
  property bool   topIsPicker: false
  property var    faderProp: null
  property string buttonLabel: ""
  property bool   buttonLit: false
  property bool   buttonVisible: true
  property bool   active: true           // false = slot empty
  property color  accent: "#ff8a1f"
  property alias  touched: fader.touched

  signal topPressed()
  signal buttonPressed()
  signal faderMoved(real v)
  signal faderNudged(real v)
  signal faderTouchStart()
  signal faderTouchEnd()

  readonly property bool discrete: (faderProp && faderProp.valueRange) ? (faderProp.valueRange.isDiscrete === true) : false
  readonly property int  steps:    (faderProp && faderProp.valueRange && faderProp.valueRange.steps) ? faderProp.valueRange.steps : 0

  function nudge(dir) {
    if (!faderProp || steps < 2) return;
    var idx = Math.round(faderProp.value * (steps - 1)) + dir;
    idx = Math.max(0, Math.min(steps - 1, idx));
    var v = idx / (steps - 1);
    faderProp.value = v;
    faderNudged(v);
  }

  TButton {
    id: topBtn
    anchors { left: parent.left; right: parent.right; top: parent.top }
    height: 58
    label: col.topLabel
    fontSize: 20
    idleColor: col.topIsPicker ? "#30343a" : "#1b1c1f"
    border.color: col.topIsPicker ? col.accent : "#1b1c1f"
    onPressed: if (col.topIsPicker) col.topPressed()
  }

  TFader {
    id: fader
    anchors { left: parent.left; right: parent.right; top: topBtn.bottom; bottom: valueText.top; topMargin: 8; bottomMargin: 4 }
    anchors.leftMargin: col.discrete ? 0 : 30
    anchors.rightMargin: col.discrete ? 70 : 30
    prop: col.faderProp
    fillColor: col.accent
    dimmed: !col.active
    onMoved: function(v) { col.faderMoved(v) }
    onTouchStart: col.faderTouchStart()
    onTouchEnd: col.faderTouchEnd()
  }

  // - / + for stepped parameters (e.g. Pattern Player sound or pattern)
  Column {
    visible: col.discrete
    anchors { right: parent.right; top: fader.top; bottom: fader.bottom }
    width: 62
    spacing: 8
    TButton { width: 62; height: (parent.height - 8) / 2; label: "+"; fontSize: 34; dimmed: !col.active; onPressed: col.nudge(1) }
    TButton { width: 62; height: (parent.height - 8) / 2; label: "−"; fontSize: 34; dimmed: !col.active; onPressed: col.nudge(-1) }
  }

  Text {
    id: valueText
    anchors { left: parent.left; right: parent.right; bottom: bottomBtn.top; bottomMargin: 6 }
    height: 24
    text: (col.active && col.faderProp && col.faderProp.description !== undefined) ? ("" + col.faderProp.description) : ""
    color: "#9aa0a8"
    font.pixelSize: 18
    horizontalAlignment: Text.AlignHCenter
    elide: Text.ElideRight
  }

  TButton {
    id: bottomBtn
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    height: 64
    visible: col.buttonVisible
    label: col.buttonLabel
    lit: col.buttonLit
    litColor: col.accent
    dimmed: !col.active
    onPressed: col.buttonPressed()
  }
}
