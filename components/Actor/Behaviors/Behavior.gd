class_name Behavior
extends Resource

@warning_ignore("unused_signal") # @virtual
signal props_changed()

var props: Dictionary = {}
        

## Used on an actor's ready event
# @virtual
func initialize(_target: Actor) -> void:
    pass

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
    pass
