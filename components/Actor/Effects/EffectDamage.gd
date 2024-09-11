class_name EffectDamage
extends Effect

@export_range(0, 100, 1, "or_greater") var damage: int = 1

func _init(_damage: int = damage) -> void:
    damage = _damage

func initialize(_target: Variant, _damage: int = damage) -> void:
    super(_target)
    damage = _damage

func execute() -> void:
    super()
    var health_behavior: Behavior = null
    for behavior in target.behaviors:
        if behavior is BehaviorHealth:
            health_behavior = behavior
    if health_behavior != null:
        print("EffectDamage applied to %s" % target.name)
        health_behavior.update(-abs(damage))
