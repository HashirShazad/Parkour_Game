extends Entity
class_name Enemy


var ghost_scene = preload("res://Character/Ghost.tscn")
var jump_sound = preload("res://Sounds/Sound/Jump.wav")

	
func _physics_process(delta):
	flip_sprite()
	update_animation()
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity  * delta
		
	elif jump_count != 0:
		jump_count = 0
	# Handle jump.

		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction 
	if !is_stunned && Engine.time_scale != 0:
			velocity.x = move_toward(velocity.x, 0, minimum_speed)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			is_pushing = 1
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		else:
			is_pushing = 0
				
func add_ghost():
	var ghost = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.play(sprite_2d.animation)
	ghost.flip_h = sprite_2d.flip_h
	ghost.sprite_2d.frame = sprite_2d.frame
	
