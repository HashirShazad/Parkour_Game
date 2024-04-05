extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@export var speed:float = 0.9

func _process(delta):
	path_follow_2d.progress_ratio += delta * speed
