extends Hit_Box
class_name Projectile_Hit_Box

@export var piercing:bool = false
@export var speed:int = 200
var direction

func _init() -> void:
	collision_layer = 2
	collision_mask = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta

