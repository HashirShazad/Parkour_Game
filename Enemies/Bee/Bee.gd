extends Entity
class_name  Flying_Enemy

var diretion : Vector2

var is_bat_chasing : bool = false

func _ready():
	gravity = 0
	
func _physics_process(delta):
	
	if sprite_2d:
		update_animation(sprite_2d)
		flip_sprite(sprite_2d)
	if is_dead:
		return
	# Add the gravity.
		
	elif jump_count != 0:
		jump_count = 0
	if !is_stunned && Engine.time_scale != 0:
		if direction:
			velocity.x = direction * speed
	move(delta)
	move_and_slide()
	check_collisions()
	
func move(delta):
	if !is_bat_chasing:
		velocity += diretion * speed * diretion


func _on_timer_timeout():
	$Timer.wait_time = choose_random([0.8,1.0,1.6])
	if !is_bat_chasing:
		diretion = choose_random([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		print(diretion)
		
func choose_random(array:Array):
	array.shuffle()
	return array.front()
