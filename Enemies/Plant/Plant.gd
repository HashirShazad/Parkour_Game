extends Enemy
class_name Plant

const  BULLET = preload("res://Enemies/Bullet.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var check_right = $Check_Right
@onready var check_left = $Check_Left


var cool_down:int = 1
var can_shoot:bool = true
var target
var direction_to_target:Vector2

func shoot():
	if can_shoot == false:
		return
		
	can_shoot = false
	#ray_cast_2d.enabled = false
	animated_sprite_2d.play("Attack")
	await get_tree().create_timer(.3).timeout
	if BULLET:
		var bullet = BULLET.instantiate()
		get_parent().get_parent().add_child(bullet)
		bullet.global_position = global_position
		bullet.direction = direction_to_target
	
	await get_tree().create_timer(cool_down).timeout
	#ray_cast_2d.enabled = true
	can_shoot = true
	animated_sprite_2d.play("Idle")
	
func _physics_process(delta):
	direction_to_target = Vector2.LEFT
	shoot()

func vec_to_dir(vec : Vector2)->Vector2:
	if vec == Vector2.ZERO:
		return Vector2.ZERO
	var ass = abs(vec.aspect())
	var res = vec.sign()
	if ass < 0.557852 or ass > 1.79259:
		res[int(ass > 1.0)] = 0
	return res
