import CSI 1.0

// Traktor Touch: lets the touch window move FX knobs 1-3 of every FX unit.
// The window writes a value and raises "active" while a fader is held; the wire then feeds the FX unit.
// Nothing is sent while "active" is false, so FX settings are untouched at startup.
Module
{
  id: module
  FxUnit { name: "tt_fx1"; channel: 1 }
  FxUnit { name: "tt_fx2"; channel: 2 }
  FxUnit { name: "tt_fx3"; channel: 3 }
  FxUnit { name: "tt_fx4"; channel: 4 }

  MappingPropertyDescriptor { id: active11; path: "mapping.state.traktor_touch.fx1.knob1.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx1.knob1.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active11.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx1.knob1.value"; input: false } to: "tt_fx1.knob1" }

  MappingPropertyDescriptor { id: active12; path: "mapping.state.traktor_touch.fx1.knob2.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx1.knob2.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active12.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx1.knob2.value"; input: false } to: "tt_fx1.knob2" }

  MappingPropertyDescriptor { id: active13; path: "mapping.state.traktor_touch.fx1.knob3.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx1.knob3.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active13.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx1.knob3.value"; input: false } to: "tt_fx1.knob3" }

  MappingPropertyDescriptor { id: active21; path: "mapping.state.traktor_touch.fx2.knob1.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx2.knob1.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active21.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx2.knob1.value"; input: false } to: "tt_fx2.knob1" }

  MappingPropertyDescriptor { id: active22; path: "mapping.state.traktor_touch.fx2.knob2.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx2.knob2.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active22.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx2.knob2.value"; input: false } to: "tt_fx2.knob2" }

  MappingPropertyDescriptor { id: active23; path: "mapping.state.traktor_touch.fx2.knob3.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx2.knob3.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active23.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx2.knob3.value"; input: false } to: "tt_fx2.knob3" }

  MappingPropertyDescriptor { id: active31; path: "mapping.state.traktor_touch.fx3.knob1.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx3.knob1.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active31.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx3.knob1.value"; input: false } to: "tt_fx3.knob1" }

  MappingPropertyDescriptor { id: active32; path: "mapping.state.traktor_touch.fx3.knob2.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx3.knob2.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active32.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx3.knob2.value"; input: false } to: "tt_fx3.knob2" }

  MappingPropertyDescriptor { id: active33; path: "mapping.state.traktor_touch.fx3.knob3.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx3.knob3.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active33.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx3.knob3.value"; input: false } to: "tt_fx3.knob3" }

  MappingPropertyDescriptor { id: active41; path: "mapping.state.traktor_touch.fx4.knob1.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx4.knob1.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active41.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx4.knob1.value"; input: false } to: "tt_fx4.knob1" }

  MappingPropertyDescriptor { id: active42; path: "mapping.state.traktor_touch.fx4.knob2.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx4.knob2.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active42.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx4.knob2.value"; input: false } to: "tt_fx4.knob2" }

  MappingPropertyDescriptor { id: active43; path: "mapping.state.traktor_touch.fx4.knob3.active"; type: MappingPropertyDescriptor.Boolean; value: false }
  MappingPropertyDescriptor { path: "mapping.state.traktor_touch.fx4.knob3.value"; type: MappingPropertyDescriptor.Float; value: 0.5; min: 0.0; max: 1.0 }
  Wire { enabled: active43.value; from: DirectPropertyAdapter { path: "mapping.state.traktor_touch.fx4.knob3.value"; input: false } to: "tt_fx4.knob3" }

}
