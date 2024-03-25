extends Area2D
class_name Hit_Box

@export var damage:float = 10
@export var stun_duration:float = .3
@export var knock_back_direction:Vector2 = Vector2(1, -1)
@export var knock_back_strength:Vector2 = Vector2(1000, 400)


func _init() -> void:
	collision_layer = 2
	collision_mask = 2
