extends Camera2D

@export var SPEED: float = 2.5

var _target: Node = null

func _process(_delta: float) -> void:
    if Global.selected_unit != null:
        _target = Global.selected_unit
    else:
        _target = null
    handle_input(_target)


func handle_input(target = null) -> void:
    var direction: Vector2 = Vector2.ZERO
    direction.x = Input.get_axis(&"move_left", &"move_right")
    direction.y = Input.get_axis(&"move_up", &"move_down")
    
    if target:
        target.position += direction * SPEED
        zoom = zoom.lerp(Vector2(2.5, 2.5), 0.1)
        position = target.position
    else:
        zoom = zoom.lerp(Vector2(2, 2), 0.1)
        position += direction * SPEED
