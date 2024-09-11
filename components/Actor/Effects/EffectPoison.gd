class_name EffectPoison
extends Effect

@export var damage: int = 1

var effect_timer: Timer = Timer.new()
var tick_timer: Timer = Timer.new()

func initialize(_target: Variant, _damage: int = damage, _tick_time: float = 1.0, _duration: float = 2.5) -> void:
    super(_target)
    damage = _damage
    effect_timer.one_shot = true
    tick_timer.one_shot = false
    
    effect_timer.timeout.connect(destroy)
    tick_timer.timeout.connect(tick)
    
    target.add_child(effect_timer)
    target.add_child(tick_timer)
    effect_timer.start(_duration)
    tick_timer.start(_tick_time)
    

func tick() -> void:
    var health_behavior: Behavior = null
    for behavior in target.behaviors:
        if behavior is BehaviorHealth:
            health_behavior = behavior
    if health_behavior == null:
        push_warning("Target %s does not have the BehaviorHealth behavior!" % target.name)
        destroy()
    else:
        health_behavior.update(-damage)


func destroy() -> void:
    super()
    effect_timer.timeout.disconnect(destroy)
    tick_timer.timeout.disconnect(tick)
    target.remove_child(effect_timer)
    target.remove_child(tick_timer)
    target.effects.remove_at(target.effects.find(self))
