class_name Unit
extends RigidBody2D

signal selection_changed(selected)

@export var is_selected:bool = false :
    get:
        return is_selected
    set(v):
        is_selected = v
        emit_signal("selection_changed", is_selected)


func _init() -> void:
    pass


func _ready() -> void:
    selection_changed.connect(on_selection_changed)


func _process(_delta: float) -> void:
    pass


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.is_pressed():
        is_selected = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton && event.is_pressed():
        is_selected = true


func on_selection_changed(selected: bool) -> void:
    if selected:
        Global.selected_unit = self
    else:
        Global.selected_unit = null
        
    $Sprite2D.scale = Vector2(
        1.2 if selected else 1.0,
        1.2 if selected else 1.0)
