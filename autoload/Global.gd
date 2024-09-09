extends Node

signal selected_unit_changed(unit: Unit)

var selected_unit: Unit = null :
    get:
        return selected_unit
    set(v):
        selected_unit = v
        selected_unit_changed.emit(selected_unit)
