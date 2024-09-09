extends Camera2D

#region Exports
@export var SPEED: float = 150.0
#endregion

#region Variables
var _target: Node = null
#endregion

#region Functions
func _process(delta: float) -> void:
    if Global.selected_unit != null:
        _target = Global.selected_unit
    else:
        _target = null
    handle_input(delta, _target)


func handle_input(delta: float, target = null) -> void:
    var direction: Vector2 = Vector2.ZERO
    direction.x = Input.get_axis(&"move_left", &"move_right")
    direction.y = Input.get_axis(&"move_up", &"move_down")
    
    if target:
        target.direction = direction
        zoom = zoom.lerp(Vector2(2.5, 2.5), 0.1)
        position = target.position
    else:
        zoom = zoom.lerp(Vector2(2, 2), 0.1)
        position += direction * SPEED * delta

func _input(event: InputEvent) -> void:
    # Right click
    if event is InputEventMouseButton &&\
       event.is_pressed() && event.button_index == 2:
        Global.target_position = get_global_mouse_position()
        Global.target_position_changed.emit(Global.target_position)
#endregion
