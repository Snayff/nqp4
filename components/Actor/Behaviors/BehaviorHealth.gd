class_name BehaviorHealth
extends BehaviorStat

@export var default_value: int = 100
@export var min_value: int = 0
@export var max_value: int = 100

func initialize(_target: Actor, _default_value: int = max_value, _min_value: int = 0, _max_value: int = max_value) -> void:
    super(_target)
    default_value = _default_value
    min_value = _min_value
    max_value = _max_value
    create_stat("health", default_value)


func update(value: int) -> void:
    update_stat("health", clampi(target.data.stats.health + value, min_value, max_value))


func destroy() -> void:
    super()
