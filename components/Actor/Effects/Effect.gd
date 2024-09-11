class_name Effect
extends Resource

@warning_ignore("unused_signal") # @virtual
signal props_changed()

var target: Actor
var props: Dictionary = {}
        

## Used on an effect's ready event
# @virtual
func initialize(_target: Actor) -> void:
    target = _target
    target.effects_changed.emit()

## Used on any sporadic event on the effect
# @virtual
func execute() -> void:
    pass

## Used on an effect's process event
# @virtual
func execute_process(_delta: float) -> void:
    pass

## Used on an effect's physics process event
# @virtual
func execute_physics_process(_delta: float) -> void:
    pass

## Optionally used when this effect is no longer relevant.
## Used for self-cleanup
# @virtual
func destroy() -> void:
    props_changed.disconnect(target.update_data)
    target.behaviors.filter(func(v):
        return v == self
    )
