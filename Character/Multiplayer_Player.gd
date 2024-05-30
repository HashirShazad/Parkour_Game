extends Player
class_name Multiplayer_Player
# Y--- Jump height is 2.5 blocks You can cover 5 blocks via double jump
# X--- 13 blocks via double jump. 15 jumps with runnin


# Variables <===================================================================================>
@onready var health_label:Label = $Label
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer
@onready var camera = $Camera2D


# Actual Code <=====================================================================>

# Enter tree


func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Called every frame
func _process(delta):
	# Subtract delta(frame) every delta(frame) from these vars
	jump_buffer_timer -= delta
	coyote_timer -= delta

# Called only once
func _ready():
	if is_multiplayer_authority():
		camera.make_current()
	# Assign ref to game manager
	update_game_manager()
	jump_buffer_timer = 0
	coyote_timer = 0

# Called every frame idk the dif between _process() and _phyiscs_process()
func _physics_process(delta):
	if silhouette_sprite:
		update_animation(silhouette_sprite)
		flip_sprite(silhouette_sprite)
	if sprite_2d:
		flip_sprite(sprite_2d)
		update_animation(sprite_2d)
	
	if is_on_floor():
		jump_count = 0
		if jump_buffer_timer > 0:
			AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
			jump_count = jump_count + 1
			velocity.y = jump_velocity
			
		if not on_ground:
			dust_particles.emitting = true
			squash()
		on_ground = true
	else:
		if on_ground:
			if !(jump_count > 0):
				coyote_timer = coyote_time
				jump_count = 1
			
			
		on_ground = false
		velocity.y += gravity  * delta 
	if is_dead:
		return
	push_off_ledges()
	
	if is_multiplayer_authority():
		handle_input()
	move_and_slide()
	check_collisions()

# Get input from user
func handle_input():
	if Input.is_action_pressed(btns.Sprint):
		speed = sprint_speed
		jump_velocity = sprint_jump_velocity
		minimum_speed = sprint_minimum_speed
		push_force = sprint_push_force
		add_ghost()
	elif Input.is_action_just_released(btns.Sprint):
		speed = def_speed
		jump_velocity = def_jump_velocity
		minimum_speed = def_minimum_speed
		push_force = def_push_force
	
	direction = Input.get_axis(btns.Left, btns.Right)
	
	if !is_stunned && Engine.time_scale != 0:
		if direction:
			kb_direction.x = direction	
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, minimum_speed)
			
		if Input.is_action_just_pressed(btns.Jump):
			if coyote_timer > 0:
				AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
				velocity.y = jump_velocity
				jump_count = 1
			elif jump_count < 2:
				if jump_count == 0:
					stretch()
				# AUDIO  (sound, volume, lower_limit, upper_limit)
				AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
				jump_count = jump_count + 1
				velocity.y = jump_velocity
			else:
				jump_buffer_timer = jump_buffer_time
		
		if Input.is_action_just_released(btns.Jump):
			if jump_count < 2:
				velocity.y *= 0.5
				
	#rpc("remote_set_position", global_position)
	

# Assign Refernces to game manager
func update_game_manager():
	GameManger.disable_ui()
	return
	#if self.name == "Player1":
		#GameManger.player_1 = self
	#elif self.name == "Player2":
		#GameManger.player_2 = self
	#GameManger.update_health()

func update_health():
	health_label.text = str(health) + "%"
# Take damage and call update_health() on game manager
func take_damage(damage:int, stun_duration:float):
	if is_dead:
		return
	if is_stunned:
		return
	health -= damage
	is_stunned = 1
	update_health()
	
	if health <= 0:
		is_dead = true
		hurt_box.set_deferred("disabled", true)
		collision_shape_2d.set_deferred("disabled", true)
		await get_tree().create_timer(.25).timeout
		
		sprite_2d.hide()
		
	jump_count = 1
	
	await get_tree().create_timer(stun_duration).timeout
	is_stunned = 0



@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position

@rpc
func display_message(message):
	pass

