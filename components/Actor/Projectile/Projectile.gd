class_name Projectile
extends RigidBody2D

#region Signals
signal behaviors_changed()
signal effects_changed()
#endregion

#region Exports
## The [Projectile]'s movement speed.
@export var speed: float = 125
## The minimum distance to the target's position before stopping.
@export var target_stop_distance: float = 30
## Direction in degrees the projectile will face
@export var direction: float = 0.0
@export var behaviors: Array[Behavior] = []
@export var effects: Array[Effect] = []
#endregion

#region Variables
## Data passed to and from [Behavior]s.
var data: Dictionary = {}

var _target_position: Vector2
var _move_to_target: bool = false
#endregion

#region Functions
func _ready() -> void:
    # NOTE: For demo purposes
    effects.push_back(EffectDamage.new(7))
    
    body_entered.connect(on_body_entered)
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
    print("Effects changed!", effects)
    for effect in effects:
        if !effect.props_changed.is_connected(update_data):
            effect.props_changed.connect(update_data.bind(effect))


func _physics_process(delta: float) -> void:
    # TODO:
    # - Handle cases where larger groups of actors can't get close
    #   enough to the target.
    # - Move to BehaviorMoveTowards
    if _move_to_target:
        apply_impulse(global_position.direction_to(_target_position) * speed * delta, global_position)
    else:
        apply_impulse(Vector2.from_angle(direction) * speed * delta, global_position)
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


func move_to_target(pos: Vector2) -> void:
    _target_position = pos
    _move_to_target = true

# @virtual
func on_body_entered(body: Node) -> void:
    # NOTE: For demo purposes
    printt("Yeppers", body, body is Actor)
    if body is Actor:
        for effect in effects:
            effect.initialize(body)
            print("Executing effect %s with target %s" % [effect, effect.target])
            effect.execute()
    queue_free()
#endregion
