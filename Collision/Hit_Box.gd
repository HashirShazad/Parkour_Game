extends Area2D
class_name Hit_Box

## Damage dealt when collided.
@export var damage:float = 10
## Stun duration in seconds
@export var stun_duration:float = .3
## Knock back strength of the vector in (x,y)
@export var knock_back_strength:Vector2 = Vector2(1000, 400)


func _init() -> void:
	collision_layer = 2
	collision_mask = 2
