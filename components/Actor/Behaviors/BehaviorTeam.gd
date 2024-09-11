class_name BehaviorTeam
extends Behavior

@export var modulate: Color = Color.WHITE
@export var team: Constants.TEAMS

func initialize(_target: Actor) -> void:
    super(_target)
    target.modulate = modulate
    props.team = team
    props_changed.emit()


func destroy() -> void:
    super()
