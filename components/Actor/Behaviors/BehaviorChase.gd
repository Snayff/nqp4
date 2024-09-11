class_name BehaviorChase
extends Behavior

var timer: Timer = Timer.new()
var chase_cooldown: float = 2.5
var chase_target: Actor = null :
    set(v):
        chase_target = v
        props.chase_target = chase_target
        props_changed.emit()
var chase: bool = false
var in_range: bool = false :
    set(v):
        in_range = v
        props.in_chase_range = in_range
        props_changed.emit()

func initialize(_target: Actor) -> void:
    super(_target)
    
    props.chase_target = chase_target
    props.in_chase_range = in_range
    props_changed.emit()
    
    target.view_range.body_entered.connect(on_view_range_entered)
    target.view_range.body_exited.connect(on_view_range_exited)
    
    timer.one_shot = true
    timer.timeout.connect(on_timer_timeout)
    
    target.add_child(timer)


func on_view_range_entered(body: Node2D) -> void:
    if body is Actor:
        if !body.data.has("team"):
            return
        if body.data.team != target.data.team:
            if chase_target == null:
                chase_target = body
            in_range = true


func on_view_range_exited(body) -> void:
    if chase_target == body:
        timer.start(chase_cooldown)
        in_range = false


func on_timer_timeout() -> void:
    if chase_target:
        if !in_range:
            chase_target = null
            timer.stop()
        else:
            timer.start(chase_cooldown)


func execute_physics_process(_delta) -> void:
    if chase_target:
        target.move_to_target(chase_target.global_position)


func destroy() -> void:
    super()
    timer.timeout.disconnect(on_timer_timeout)
    target.remove_child(timer)
