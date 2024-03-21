extends Area2D

@export var fruit_name:StringName 
func _ready():
	$AnimatedSprite2D.play(fruit_name)

