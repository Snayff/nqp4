class_name Actor
extends RigidBody2D

#region Signals
## Emitted every time the selection state changes.
signal selection_changed(selected: bool)
#endregion

#region Exports
## The [Actor]'s movement speed.
@export var speed: float = 125
## The minimum distance to the target's position before stopping.
@export var target_stop_distance: float = 30
## Whether the [Actor] is selected (controlled) or not.
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
var _target_position: Vector2
var _move_to_target: bool = false
#endregion

#region Functions
func _init() -> void:
    pass


func _ready() -> void:
    selection_changed.connect(on_selection_changed)
    Global.target_position_changed.connect(move_to_target)
    if Global.DEBUG.actor_hover_print:
        mouse_entered.connect(func(): print("Mouse entered over %s" % self))
        mouse_exited.connect(func(): print("Mouse exited over %s" % self))


func _physics_process(delta: float) -> void:
    if is_selected:
        apply_impulse(direction * speed * delta, global_position)
    else:
        # TODO: Handle cases where larger groups of actors can't get close enough to the target
        if _move_to_target && global_position.distance_to(_target_position) > target_stop_distance:
            apply_impulse(global_position.direction_to(_target_position) * speed * delta, global_position)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.is_pressed():
        is_selected = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton && event.is_pressed():
        is_selected = true


func on_selection_changed(selected: bool) -> void:
    if selected:
        Global.selected_actor = self
    else:
        Global.selected_actor = null
        
    $Sprite2D.scale = Vector2(1.2 if selected else 1.0, 1.2 if selected else 1.0)


func move_to_target(pos: Vector2) -> void:
    #print("New target position is %s" % pos)
    _target_position = pos
    _move_to_target = true
#endregion
