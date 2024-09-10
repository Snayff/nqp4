extends Node

const DEBUG: Dictionary = {
    "actor_hover_print": false,
    "spawn_spiral": true,
    "print_selected_actor_data": true,
    "draw_actor_debug": true
}

#region selected_actor
## Emitted every time the selected actor changes.
signal selected_actor_changed(actor: Actor)
## Globally accessible selected [Actor].
var selected_actor: Actor = null :
    get:
        return selected_actor
    set(v):
        selected_actor = v
        selected_actor_changed.emit(selected_actor)
#endregion

#region target_position
@warning_ignore("unused_signal") # The signal is used, just not here.
signal target_position_changed(position: Vector2)
var target_position: Vector2 = Vector2.ZERO
#endregion

#region Functions
func spawn_spiral() -> void:
    const actor_scene: Resource = preload("res://components/Actor/ExampleActor/ExampleActor.tscn")
    const angle_step: float = 5
    const distance: float = 5
    const center: Vector2 = Vector2.ZERO
    var actor_parent: Node2D = get_tree().get_root().get_node("Main/Actors")

    for i in range(2):
        var angle: float = i * angle_step
        var radius: float = i * distance / (2 * PI)
        var x: float = center.x + radius * cos(angle)
        var y: float = center.y + radius * sin(angle)
        var position: Vector2 = Vector2(x, y)
        var actor: Actor = actor_scene.instantiate()
        
        actor.position = position
        var team = BehaviorTeam.new()
        if i % 2:
            team.team = Constants.TEAMS.ENEMY
            team.modulate = Color.RED
            actor.behaviors.push_back(BehaviorChase.new())
        else:
            team.team = Constants.TEAMS.FRIENDLY
        actor.behaviors.push_back(team)
        actor_parent.add_child(actor)


func _ready() -> void:
    # For debug purposes only
    if DEBUG.spawn_spiral:
        spawn_spiral()


func _input(_event: InputEvent) -> void:
    if Input.is_action_just_released(&"ui_accept"):
        release_actor()


func release_actor() -> void:
    selected_actor.is_selected = false
    selected_actor = null
#endregion
