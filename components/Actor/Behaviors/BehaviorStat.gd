class_name BehaviorStat
extends Behavior


# NOTE: May be worth to make this work with a Stat resource which holds
#       individual stats.
func initialize(_target: Actor) -> void:
    super(_target)
    target.data.stats = {}
    props_changed.emit()


func create_stat(stat_name: String, default_value: Variant) -> bool:
    if target.data.stats.has(stat_name):
        return false
    target.data.stats[stat_name] = default_value
    props_changed.emit()
    return true


func remove_stat(stat_name: String) -> bool:
    if !target.data.stats.has(stat_name):
        return false
    var removed: bool = target.data.stats.erase(stat_name)
    if removed:
        props_changed.emit()
    return removed


func update_stat(stat_name: String, new_value: Variant) -> bool:
    if !target.data.stats.has(stat_name):
        return false
    target.data.stats[stat_name] = new_value
    props_changed.emit()
    return true


func destroy() -> void:
    super()
