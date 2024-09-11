class_name Behavior
extends Resource

@warning_ignore("unused_signal") # @virtual
signal props_changed()

var target: Variant
var props: Dictionary = {}
        

## Used on an actor's ready event
# @virtual
func initialize(_target: Variant) -> void:
    assert(_target is Actor || _target is Projectile, "Target is neither Actor nor Projectile")
    target = _target
    target.behaviors_changed.emit()

## Used on any sporadic event on the actor
# @virtual
func execute() -> void:
    pass

## Used on an actor's process event
# @virtual
func execute_process(_delta: float) -> void:
    pass

## Used on an actor's physics process event
# @virtual
func execute_physics_process(_delta: float) -> void:
    pass

## Optionally used when this behavior is no longer relevant.
## Used for self-cleanup
# @virtual
func destroy() -> void:
    props_changed.disconnect(target.update_data)
    target.behaviors.remove_at(target.behaviors.find(self))
