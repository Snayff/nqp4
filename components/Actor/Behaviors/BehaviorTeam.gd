class_name BehaviorTeam
extends Behavior

@export var modulate: Color = Color.WHITE
@export var team: Constants.TEAMS

func initialize(target: Actor) -> void:
    super(target)
    target.modulate = modulate
    props.team = team
    props_changed.emit()
