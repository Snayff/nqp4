extends Node

const DEBUG: bool = true

## Emitted every time the selected unit changes.
signal selected_unit_changed(unit: Unit)

## Globally accessible selected [Unit].
var selected_unit: Unit = null :
    get:
        return selected_unit
    set(v):
        selected_unit = v
        selected_unit_changed.emit(selected_unit)
