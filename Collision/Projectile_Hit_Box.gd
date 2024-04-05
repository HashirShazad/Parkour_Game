extends Hit_Box
class_name Projectile_Hit_Box

@export var piercing:bool = false
@export var speed:int = 200
@export var direction:int 
@onready var sprite_2d = $".."

func _init() -> void:
	collision_layer = 2
	collision_mask = 2
		
func _ready():
	if sprite_2d.flip_h == true:
		direction = 1
	elif sprite_2d.flip_h == false:
		direction = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x += speed * direction * delta


func destroy():
	if piercing:
		return
	queue_free()
