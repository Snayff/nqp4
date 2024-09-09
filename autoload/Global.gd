extends Node

const DEBUG: Dictionary = {
    "unit_hover_print": false,
    "spawn_spiral": true
}

#region selected_unit
## Emitted every time the selected unit changes.
signal selected_unit_changed(unit: Unit)
## Globally accessible selected [Unit].
var selected_unit: Unit = null :
    get:
        return selected_unit
    set(v):
        selected_unit = v
        selected_unit_changed.emit(selected_unit)
#endregion

#region target_position
@warning_ignore("unused_signal") # The signal is used, just not here.
signal target_position_changed(position: Vector2)
var target_position: Vector2 = Vector2.ZERO
#endregion

#region Functions
func spawn_spiral() -> void:
    const unit_scene: Resource = preload("res://components/Unit/Unit.tscn")
    const angle_step: float = 5
    const distance: float = 5
    const center: Vector2 = Vector2.ZERO
    var unit_parent: Node2D = get_tree().get_root().get_child(1).find_child("Units")

    for i in range(1000):
        var angle: float = i * angle_step
        var radius: float = i * distance / (2 * PI)
        var x: float = center.x + radius * cos(angle)
        var y: float = center.y + radius * sin(angle)
        var position: Vector2 = Vector2(x, y)
        var unit: Unit = unit_scene.instantiate()
        
        unit.position = position
        unit_parent.add_child(unit)


func _ready() -> void:
    # For debug purposes only
    if DEBUG.spawn_spiral:
        spawn_spiral()


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_released(&"ui_accept"):
        release_unit()


func release_unit() -> void:
    selected_unit.is_selected = false
    selected_unit = null
#endregion
