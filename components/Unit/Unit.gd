class_name Unit
extends RigidBody2D

#region Signals
## Emitted every time the selection state changes.
signal selection_changed(selected: bool)
#endregion

#region Exports
## The [Unit]'s movement speed.
@export var speed: float = 125
## Whether the [Unit] is selected (controlled) or not.
@export var is_selected:bool = false :
    get:
        return is_selected
    set(v):
        is_selected = v
        emit_signal("selection_changed", is_selected)
#endregion

#region Variables
## Directional input passed from the Camera.
var direction: Vector2 = Vector2.ZERO
#endregion

#region Functions
func _init() -> void:
    pass


func _ready() -> void:
    selection_changed.connect(on_selection_changed)
    if Global.DEBUG:
        mouse_entered.connect(func(): print("Mouse entered over %s" % self))
        mouse_exited.connect(func(): print("Mouse exited over %s" % self))


func _process(delta: float) -> void:
    if is_selected:
        global_position += direction * speed * delta


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
        
    $Sprite2D.scale = Vector2(1.2 if selected else 1.0, 1.2 if selected else 1.0)
#endregion
