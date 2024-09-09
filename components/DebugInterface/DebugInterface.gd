extends Control

@export var label: Label
@export var actors_label: Label
@export var actors: Node2D

func _process(_delta: float) -> void:
    label.text = "FPS: %s" % Engine.get_frames_per_second()
    actors_label.text = "Actors: %s" % actors.get_child_count()
