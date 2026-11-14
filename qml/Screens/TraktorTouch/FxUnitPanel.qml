import CSI 1.0
import QtQuick 2.0

// Full control of one Traktor FX unit: Group / Single / Pattern Player.
Rectangle {
  id: panel

  property int  unit: 1                 // 1..4
  property bool unitAvailable: true     // false when Traktor runs in 2-FX-unit mode and unit > 2
  property bool touchMode: false        // fader touch switches the effect on, release switches it off

  signal pickerRequested(string title, var prop)

  readonly property string base: "app.traktor.fx." + unit
  readonly property bool isGroup:   fxType.value == FxType.Group
  readonly property bool isSingle:  fxType.value == FxType.Single
  readonly property bool isPattern: fxType.value == FxType.PatternPlayer
  readonly property color accent:   isPattern ? "#3fe0b0" : "#ff8a1f"

  color: "#0e0f11"
  border.width: 2
  border.color: "#2a2c30"

  //--------------------------------------------------------------------------------------------------------------------
  // Traktor properties
  AppProperty { id: fxType;    path: panel.base + ".type" }
  AppProperty { id: fxRouting; path: panel.base + ".routing" }
  AppProperty { id: fxEnabled; path: panel.base + ".enabled" }
  AppProperty { id: fxDryWet;  path: panel.base + ".dry_wet" }
  AppProperty { id: fxStore;   path: panel.base + ".store" }

  AppProperty { id: fxSelect1; path: panel.base + ".select.1" }
  AppProperty { id: fxSelect2; path: panel.base + ".select.2" }
  AppProperty { id: fxSelect3; path: panel.base + ".select.3" }

  AppProperty { id: fxParam1;  path: panel.base + ".parameters.1" }
  AppProperty { id: fxParam2;  path: panel.base + ".parameters.2" }
  AppProperty { id: fxParam3;  path: panel.base + ".parameters.3" }

  AppProperty { id: fxKnob1Name; path: panel.base + ".knobs.1.name" }
  AppProperty { id: fxKnob2Name; path: panel.base + ".knobs.2.name" }
  AppProperty { id: fxKnob3Name; path: panel.base + ".knobs.3.name" }

  AppProperty { id: fxButton1; path: panel.base + ".buttons.1" }
  AppProperty { id: fxButton2; path: panel.base + ".buttons.2" }
  AppProperty { id: fxButton3; path: panel.base + ".buttons.3" }
  AppProperty { id: fxButton1Name; path: panel.base + ".buttons.1.name" }
  AppProperty { id: fxButton2Name; path: panel.base + ".buttons.2.name" }
  AppProperty { id: fxButton3Name; path: panel.base + ".buttons.3.name" }

  AppProperty { id: kitSelect;    path: panel.base + ".kitSelect" }
  AppProperty { id: kitName;      path: panel.base + ".pattern_player.kit_shortname" }
  AppProperty { id: currentStep;  path: panel.base + ".pattern_player.current_step" }
  AppProperty { id: currentSound; path: panel.base + ".pattern_player.current_sound" }
  AppProperty { id: clearPattern; path: panel.base + ".pattern_player.clear_pattern" }

  AppProperty { id: assignA; path: "app.traktor.mixer.channels.1.fx.assign." + panel.unit }
  AppProperty { id: assignB; path: "app.traktor.mixer.channels.2.fx.assign." + panel.unit }
  AppProperty { id: assignC; path: "app.traktor.mixer.channels.3.fx.assign." + panel.unit }
  AppProperty { id: assignD; path: "app.traktor.mixer.channels.4.fx.assign." + panel.unit }

  //--------------------------------------------------------------------------------------------------------------------
  // Helpers
  function txt(p) { return (p && p.value !== undefined && p.value !== null) ? ("" + p.value) : "" }
  function desc(p) {
    if (!p) return "";
    if (p.description !== undefined && p.description !== null && ("" + p.description) !== "") return "" + p.description;
    return txt(p);
  }
  function routingLabel() {
    if (fxRouting.value == FxRouting.Insert) return "INSERT";
    if (fxRouting.value == FxRouting.PostFader) return "POST FADER";
    return "SEND";
  }
  function nextRouting() {
    if (fxRouting.value == FxRouting.Send) fxRouting.value = FxRouting.Insert;
    else if (fxRouting.value == FxRouting.Insert) fxRouting.value = FxRouting.PostFader;
    else fxRouting.value = FxRouting.Send;
  }

  // touch mode: how many faders are currently held (Single mode shares one ON switch)
  property int heldFaders: 0
  function faderDown(slot) {
    if (!touchMode || isPattern) return;
    if (isGroup) {
      if (slot == 1) fxButton1.value = true;
      if (slot == 2) fxButton2.value = true;
      if (slot == 3) fxButton3.value = true;
    } else if (isSingle) {
      heldFaders += 1;
      fxEnabled.value = true;
    }
  }
  function faderUp(slot) {
    if (!touchMode || isPattern) return;
    if (isGroup) {
      if (slot == 1) fxButton1.value = false;
      if (slot == 2) fxButton2.value = false;
      if (slot == 3) fxButton3.value = false;
    } else if (isSingle) {
      heldFaders = Math.max(0, heldFaders - 1);
      if (heldFaders == 0) fxEnabled.value = false;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Header: unit name, mode, routing, snapshot, touch mode, deck assign
  Item {
    id: header
    anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
    height: 60

    Row {
      anchors.fill: parent
      spacing: 8

      Rectangle {
        width: 76; height: 60; radius: 8; color: panel.accent
        Text { anchors.centerIn: parent; text: "FX " + panel.unit; font.pixelSize: 26; font.bold: true; color: "#101010" }
      }

      TButton { width: 92;  height: 60; label: "GROUP";   fontSize: 16; lit: panel.isGroup;   onPressed: fxType.value = FxType.Group }
      TButton { width: 92;  height: 60; label: "SINGLE";  fontSize: 16; lit: panel.isSingle;  onPressed: fxType.value = FxType.Single }
      TButton { width: 104; height: 60; label: "PATTERN"; fontSize: 16; lit: panel.isPattern; litColor: "#3fe0b0"; onPressed: fxType.value = FxType.PatternPlayer }
      TButton { width: 112; height: 60; label: panel.routingLabel(); fontSize: 15; onPressed: panel.nextRouting() }
      TButton { width: 70;  height: 60; label: "SNAP";  fontSize: 15; visible: !panel.isPattern; onPressed: fxStore.value = true }
      TButton { width: 80;  height: 60; label: "TOUCH"; fontSize: 15; visible: !panel.isPattern; lit: panel.touchMode; litColor: "#4aa3ff"; onPressed: panel.touchMode = !panel.touchMode }
    }

    Row {
      anchors { right: parent.right; top: parent.top }
      spacing: 6
      TButton { width: 50; height: 60; label: "A"; lit: assignA.value == true; litColor: panel.accent; onPressed: assignA.value = !assignA.value }
      TButton { width: 50; height: 60; label: "B"; lit: assignB.value == true; litColor: panel.accent; onPressed: assignB.value = !assignB.value }
      TButton { width: 50; height: 60; label: "C"; lit: assignC.value == true; litColor: panel.accent; onPressed: assignC.value = !assignC.value }
      TButton { width: 50; height: 60; label: "D"; lit: assignD.value == true; litColor: panel.accent; onPressed: assignD.value = !assignD.value }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Four control columns
  Row {
    id: columns
    anchors { left: parent.left; right: parent.right; top: header.bottom; bottom: patternArea.top; margins: 12 }
    spacing: 12
    readonly property real colWidth: (width - 3 * spacing) / 4

    // Column 0: dry/wet (Group), effect + amount (Single), kit + volume (Pattern Player)
    FxColumn {
      width: columns.colWidth; height: columns.height
      accent: panel.accent
      topIsPicker: panel.isSingle || panel.isPattern
      topLabel: panel.isGroup ? "DRY / WET" : (panel.isSingle ? panel.desc(fxSelect1) : (panel.desc(kitName) !== "" ? panel.desc(kitName) : "KIT"))
      faderProp: fxDryWet
      buttonVisible: !panel.isGroup
      buttonLabel: "ON"
      buttonLit: fxEnabled.value == true
      onTopPressed: panel.isPattern ? panel.pickerRequested("FX " + panel.unit + "  •  Drum kit", kitSelect)
                                    : panel.pickerRequested("FX " + panel.unit + "  •  Effect", fxSelect1)
      onButtonPressed: fxEnabled.value = !fxEnabled.value
      onFaderTouchStart: panel.faderDown(0)
      onFaderTouchEnd: panel.faderUp(0)
    }

    FxColumn {
      width: columns.colWidth; height: columns.height
      accent: panel.accent
      topIsPicker: panel.isGroup
      topLabel: panel.isGroup ? panel.desc(fxSelect1) : (panel.isPattern ? panel.desc(currentSound) : panel.txt(fxKnob1Name))
      faderProp: fxParam1
      active: panel.isGroup ? (fxSelect1.value != 0) : (panel.isPattern || panel.txt(fxKnob1Name) !== "")
      buttonLabel: panel.txt(fxButton1Name) !== "" ? panel.txt(fxButton1Name) : "ON"
      buttonLit: fxButton1.value == true
      onTopPressed: panel.pickerRequested("FX " + panel.unit + "  •  Slot 1", fxSelect1)
      onButtonPressed: fxButton1.value = !fxButton1.value
      onFaderTouchStart: panel.faderDown(1)
      onFaderTouchEnd: panel.faderUp(1)
    }

    FxColumn {
      width: columns.colWidth; height: columns.height
      accent: panel.accent
      topIsPicker: panel.isGroup
      topLabel: panel.isGroup ? panel.desc(fxSelect2) : panel.txt(fxKnob2Name)
      faderProp: fxParam2
      active: panel.isGroup ? (fxSelect2.value != 0) : (panel.isPattern || panel.txt(fxKnob2Name) !== "")
      buttonLabel: panel.txt(fxButton2Name) !== "" ? panel.txt(fxButton2Name) : "ON"
      buttonLit: fxButton2.value == true
      onTopPressed: panel.pickerRequested("FX " + panel.unit + "  •  Slot 2", fxSelect2)
      onButtonPressed: fxButton2.value = !fxButton2.value
      onFaderTouchStart: panel.faderDown(2)
      onFaderTouchEnd: panel.faderUp(2)
    }

    FxColumn {
      width: columns.colWidth; height: columns.height
      accent: panel.accent
      topIsPicker: panel.isGroup
      topLabel: panel.isGroup ? panel.desc(fxSelect3) : panel.txt(fxKnob3Name)
      faderProp: fxParam3
      active: panel.isGroup ? (fxSelect3.value != 0) : (panel.isPattern || panel.txt(fxKnob3Name) !== "")
      buttonLabel: panel.txt(fxButton3Name) !== "" ? panel.txt(fxButton3Name) : "ON"
      buttonLit: fxButton3.value == true
      onTopPressed: panel.pickerRequested("FX " + panel.unit + "  •  Slot 3", fxSelect3)
      onButtonPressed: fxButton3.value = !fxButton3.value
      onFaderTouchStart: panel.faderDown(3)
      onFaderTouchEnd: panel.faderUp(3)
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Pattern Player: 16 steps + clear
  Item {
    id: patternArea
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: 12; rightMargin: 12; bottomMargin: panel.isPattern ? 12 : 0 }
    height: panel.isPattern ? 128 : 0
    visible: panel.isPattern

    Grid {
      id: stepGrid
      anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
      width: parent.width - 120
      columns: 8
      spacing: 8
      readonly property real cellW: (width - 7 * spacing) / 8
      readonly property real cellH: (height - spacing) / 2

      Repeater {
        id: stepRepeater
        model: 16
        Rectangle {
          id: stepCell
          AppProperty { id: stepState; path: panel.base + ".pattern_player.steps." + (index + 1) + ".state" }
          readonly property bool on: stepState.value == true
          readonly property bool playing: currentStep.value == index
          function setOn(v) { if (stepCell.on != v) stepState.value = v }

          width: stepGrid.cellW
          height: stepGrid.cellH
          radius: 6
          color: on ? "#3fe0b0" : ((index % 4 == 0) ? "#2b2f35" : "#1d1f23")
          border.width: playing ? 4 : 2
          border.color: playing ? "#ffffff" : "#3a3d43"

          Text {
            anchors.centerIn: parent
            text: index + 1
            font.pixelSize: 18
            font.bold: true
            color: stepCell.on ? "#101010" : "#70757d"
          }

        }
      }
    }

    // One finger paints steps: the first step touched decides on/off, every step the finger crosses follows.
    TouchSurface {
      id: stepPaint
      anchors.fill: stepGrid
      property bool paintValue: true
      property int  lastIndex: -1

      function indexAt(px, py) {
        if (px < 0 || py < 0 || px >= width || py >= height) return -1;
        var c = Math.min(7, Math.floor(px / (stepGrid.cellW + stepGrid.spacing)));
        var r = Math.min(1, Math.floor(py / (stepGrid.cellH + stepGrid.spacing)));
        return r * 8 + c;
      }
      function paint(px, py, first) {
        var i = indexAt(px, py);
        if (i < 0 || i == lastIndex) return;
        var cell = stepRepeater.itemAt(i);
        if (!cell) return;
        if (first) paintValue = !cell.on;
        cell.setOn(paintValue);
        lastIndex = i;
      }

      onDown: function(px, py) { lastIndex = -1; paint(px, py, true) }
      onDrag: function(px, py) { paint(px, py, false) }
      onUp: lastIndex = -1
    }

    TButton {
      anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
      width: 108
      label: "CLEAR"
      fontSize: 18
      litColor: "#ff4d4d"
      onPressed: clearPattern.value = true
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  // Shown for FX 3 / FX 4 when Traktor is set to two FX units
  Rectangle {
    anchors.fill: parent
    visible: !panel.unitAvailable
    color: "#e6101113"
    MultiPointTouchArea { anchors.fill: parent }   // swallow touches
    Text {
      anchors.centerIn: parent
      width: parent.width - 80
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.WordWrap
      color: "#9aa0a8"
      font.pixelSize: 26
      text: "FX " + panel.unit + " is off.\nPreferences → Effects → FX Unit Routing → 4 FX Units"
    }
  }
}
