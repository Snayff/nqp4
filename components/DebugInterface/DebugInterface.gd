extends Control

@export var label: Label
@export var units_label: Label
@export var units: Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    label.text = "FPS: %s" % Engine.get_frames_per_second()
    units_label.text = "Units: %s" % units.get_child_count()
