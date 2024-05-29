extends Enemy
class_name Pig

func _ready():
	health = max_health
	if randf_range(-1, 1) > 0:
		direction = 1
	else:
		direction = -1
		
func _physics_process(delta):
	
	if sprite_2d:
		update_animation(sprite_2d)
		flip_sprite(sprite_2d)
	var found_wall = is_on_wall()
	if found_wall:
		direction *= -1
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity  * delta
		
	elif jump_count != 0:
		jump_count = 0
	if !is_stunned && Engine.time_scale != 0:
		if direction:
			velocity.x = direction * speed
	move_and_slide()
	check_collisions()
