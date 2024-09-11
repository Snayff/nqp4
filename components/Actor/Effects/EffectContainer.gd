class_name EffectContainer
extends Effect

@export var effects: Array[Effect] = []

func initialize(_target: Variant) -> void:
    target = _target
    for effect in effects:
        effect.initialize(target)
    target.effects_changed.emit()

func execute() -> void:
    for effect in effects:
        effect.execute()

func execute_process(delta: float) -> void:
    for effect in effects:
        effect.execute_process(delta)

## Used on an effect's physics process event
# @virtual
func execute_physics_process(delta: float) -> void:
    for effect in effects:
        effect.execute_physics_process(delta)

## Optionally used when this effect is no longer relevant.
## Used for self-cleanup
# @virtual
func destroy() -> void:
    super()
    for effect in effects:
        effect.destroy()
