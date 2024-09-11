class_name Actor
extends RigidBody2D

#region Signals
## Emitted every time the selection state changes.
signal selection_changed(selected: bool)
signal behaviors_changed()
signal effects_changed()
#endregion

#region Exports
## The [Actor]'s movement speed.
@export var speed: float = 125
## The minimum distance to the target's position before stopping.
@export var target_stop_distance: float = 30
## Whether the [Actor] is selected or not.
#  NOTE: consider moving to a dedicated BehaviorSelectable
@export var is_selected:bool = false :
    set(v):
        is_selected = v
        emit_signal("selection_changed", is_selected)
@export var behaviors: Array[Behavior] = []
@export var effects: Array[Effect] = []
#endregion

#region On Ready
@onready var view_range = $ViewRange
#endregion

#region Variables
## Directional input passed from the Camera.
var direction: Vector2 = Vector2.ZERO
## Data passed to and from [Behavior]s.
var data: Dictionary = {}

var _target_position: Vector2
var _move_to_target: bool = false
#endregion

#region Functions
func _ready() -> void:
    selection_changed.connect(on_selection_changed)
    behaviors_changed.connect(connect_behaviors)
    effects_changed.connect(connect_effects)
    
    Global.target_position_changed.connect(move_to_target)
    if Global.DEBUG.actor_hover_print:
        mouse_entered.connect(func(): print("Mouse entered over %s" % self))
        mouse_exited.connect(func(): print("Mouse exited over %s" % self))
    
    connect_behaviors()
    connect_effects()


func update_data(resource) -> void:
    data.merge(resource.props, false)
    if resource.props != data:
        resource.props = data


func connect_behaviors() -> void:
    for behavior in behaviors:
        if !behavior.props_changed.is_connected(update_data):
            behavior.props_changed.connect(update_data.bind(behavior))
            behavior.initialize(self)


func connect_effects() -> void:
    for effect in effects:
        if !effect.props_changed.is_connected(update_data):
            effect.props_changed.connect(update_data.bind(effect))
            effect.initialize(self)


func _physics_process(delta: float) -> void:
    if is_selected:
        apply_impulse(direction * speed * delta, global_position)
    else:
        # TODO:
        # - Handle cases where larger groups of actors can't get close
        #   enough to the target.
        # - Move to BehaviorMoveTowards
        if _move_to_target:
            if in_target_range():
                apply_impulse(global_position.direction_to(_target_position) * speed * delta, global_position)
            else:
                _move_to_target = false
    for behavior in behaviors:
        behavior.execute_physics_process(delta)
    for effect in effects:
        effect.execute_physics_process(delta)


func _process(delta: float) -> void:
    if Global.DEBUG.draw_actor_debug:
        queue_redraw()
    
    for behavior in behaviors:
        behavior.execute_process(delta)
    for effect in effects:
        effect.execute_process(delta)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton && event.is_pressed():
        is_selected = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton && event.is_pressed():
        is_selected = true


func on_selection_changed(_selected: bool) -> void:
    if _selected:
        if Global.DEBUG.print_selected_actor_data:
            print("Data:", data)
        Global.selected_actor = self
        on_selected()
    else:
        Global.selected_actor = null
        on_deselected()
        
    $Sprite2D.scale = Vector2(1.2 if _selected else 1.0, 1.2 if _selected else 1.0)


func move_to_target(pos: Vector2) -> void:
    _target_position = pos
    _move_to_target = true


func in_target_range() -> bool:
    return global_position.distance_to(_target_position) > target_stop_distance


func _draw() -> void:
    if Global.DEBUG.draw_actor_debug:
        var offset: float = 0
        var keys = data.keys()
        keys.reverse()
        for key in keys:
            draw_string(
                ThemeDB.fallback_font,
                Vector2(0, -16 + offset),
                "%s: %s" % [key, data[key]],
                HORIZONTAL_ALIGNMENT_CENTER,
                -1,
                8
            )
            offset -= 12
#endregion

#region Virtuals
## @virtual
func on_selected() -> void:
    pass


## @virtual
func on_deselected() -> void:
    pass
#endregion
