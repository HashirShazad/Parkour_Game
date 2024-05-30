extends Entity
class_name Player
# Y--- Jump height is 2.5 blocks You can cover 5 blocks via double jump
# X--- 13 blocks via double jump. 15 jumps with runnin


# Variables <===================================================================================>
# Scenes <----------------------------------------------------------------------------------------->
var ghost_scene = preload("res://Character/Ghost.tscn")
var jump_sound = preload("res://Sounds/Sound/Jump.wav")

# Miscellanous <----------------------------------------------------------------------------------------->
#Constants
const WALL_JUMP_PUSHBACK = 1000
const jump_buffer_time:float = .1
const coyote_time:float = .1

#Variables
var jump_buffer_timer:float = 0
var coyote_timer:float = 0
var carried_player_ref:Player = null
# Ray Cast references <--------------------------------------------------------------------------->
@export_group("Ray Casts")
@export var right_outer:RayCast2D 
@export var left_outer:RayCast2D
@export var right_inner:RayCast2D
@export var left_inner:RayCast2D



# Buttons <----------------------------------------------------------------------------------------->

## Buttons to be pressed
@export_group("Buttons")
@export var btns = {
	 Right = "P1_Right",
	 Left = "P1_Left",
	 Jump = "P1_Jump",
	 Sprint = "P1_Sprint",
}

# Actual Code <=====================================================================>

# Called every frame
func _process(delta):
	# Subtract delta(frame) every delta(frame) from these vars
	jump_buffer_timer -= delta
	coyote_timer -= delta

# Called only once
func _ready():
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
		update_animation(sprite_2d)
		flip_sprite(sprite_2d)
		
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
	handle_input()
	move_and_slide()
	check_collisions()

# Take damage and call update_health() on game manager
func take_damage(damage:int, stun_duration:float):
	if is_dead:
		return
	if is_stunned:
		return
	health -= damage
	is_stunned = 1
	GameManger.update_health()
	
	if health <= 0:
		is_dead = true
		hurt_box.set_deferred("disabled", true)
		collision_shape_2d.set_deferred("disabled", true)
		await get_tree().create_timer(.25).timeout
		
		sprite_2d.hide()
		
	jump_count = 1
	
	await get_tree().create_timer(stun_duration).timeout
	is_stunned = 0

# Add ghosts when running
func add_ghost():
	var ghost = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.play(sprite_2d.animation)
	ghost.flip_h = sprite_2d.flip_h
	ghost.sprite_2d.frame = sprite_2d.frame
	
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

# Assign Refernces to game manager
func update_game_manager():
	if self.name == "Player1":
		GameManger.player_1 = self
	elif self.name == "Player2":
		GameManger.player_2 = self
	GameManger.update_health()

# Push the character if its slightly touching a ledge from underneath so that he can jump
func push_off_ledges():
	if !is_instance_valid(right_outer) or  !is_instance_valid(left_outer):
		return
	elif !is_instance_valid(right_inner) or !is_instance_valid(left_inner):
		return
	 # Arbitrary offset, adjust as needed, or even use the raycasts to determine exactly how much to move
	if right_outer.is_colliding() and !right_inner.is_colliding() \
		and left_inner.is_colliding() and !left_outer.is_colliding():
			self.global_position.x -= 5
	elif left_outer.is_colliding() and !left_inner.is_colliding() \
		and !right_inner.is_colliding() and !right_outer.is_colliding():
			self.global_position.x += 5

func revive(rev_pos:Vector2):
	health = max_health
	if is_dead:
		is_dead = false
		update_game_manager()
		hurt_box.set_deferred("disabled", false)
		collision_shape_2d.set_deferred("disabled", false)
		self.global_position = rev_pos
		is_respawning = true
		velocity = Vector2(0, 0)
		sprite_2d.show()
		await get_tree().create_timer(.1).timeout
		is_respawning = false
		
