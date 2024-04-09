extends Enemy
class_name Shooting_Enemies

const  BULLET = preload("res://Enemies/Plant/Bullet.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
var cool_down:int = 1
var can_shoot:bool = true
var target

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
	
	await get_tree().create_timer(cool_down).timeout
	#ray_cast_2d.enabled = true
	can_shoot = true
	animated_sprite_2d.play("Idle")
	
func _physics_process(delta):
	if target != null:
		var angle_to_target:float = global_position.direction_to(target.global_position).angle()
		shoot()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Players"):
		target = body
