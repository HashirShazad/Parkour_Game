extends Entity
class_name Player


var ghost_scene = preload("res://Character/Ghost.tscn")
var jump_sound = preload("res://Sounds/Sound/Jump.wav")


const WALL_JUMP_PUSHBACK = 1000
const jump_buffer_time:float = .1

var jump_buffer_timer:float = 0

@onready var right_outer = $Right_Outer
@onready var left_outer = $Left_Outer
@onready var right_inner = $Right_Inner
@onready var left_inner = $Left_Inner



@export var btns = {
	 Right = "P1_Right",
	 Left = "P1_Left",
	 Jump = "P1_Jump",
	 Sprint = "P1_Sprint",
}
func _process(delta):
	jump_buffer_timer -= delta
	
func _ready():
	update_game_manager()
	jump_buffer_timer = 0
	
func _physics_process(delta):
	flip_sprite()
	update_animation()
	
	if is_on_floor():
		jump_count = 0
		if jump_buffer_timer > 0:
			AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
			jump_count = jump_count + 1
			velocity.y = jump_velocity
			
		if not on_ground:
			dust_particles.emitting = true
		on_ground = true
	else:
		on_ground = false
		velocity.y += gravity  * delta
	if is_dead:
		return
	push_off_ledges()
	handle_input()
	move_and_slide()
	check_collisions()
				

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

func add_ghost():
	var ghost = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.play(sprite_2d.animation)
	ghost.flip_h = sprite_2d.flip_h
	ghost.sprite_2d.frame = sprite_2d.frame
	
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
			#if is_on_wall() and Input.is_action_pressed(btns.Right):
				#velocity.y = jump_velocity
				#AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
				#velocity.x = WALL_JUMP_PUSHBACK
			#elif is_on_wall() and Input.is_action_pressed(btns.Left):
				#velocity.y = jump_velocity
				#AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
				#velocity.x = WALL_JUMP_PUSHBACK
			if jump_count < 2:
				# AUDIO  (sound, volume, lower_limit, upper_limit)
				AudioPlayer.play_FX(jump_sound, 0, 1, 1.5)
				jump_count = jump_count + 1
				velocity.y = jump_velocity
			else:
				jump_buffer_timer = jump_buffer_time

func update_game_manager():
	if self.name == "Player1":
		GameManger.player_1 = self
	elif self.name == "Player2":
		GameManger.player_2 = self
	#GameManger.death_screen.hide()

func push_off_ledges():
	return
	# Still in development
	 # Arbitrary offset, adjust as needed, or even use the raycasts to determine exactly how much to move
	if right_outer.is_colliding() and !right_inner.is_colliding() \
		and left_inner.is_colliding() and !left_outer.is_colliding():
			self.global_position.x -= 5
	elif left_outer.is_colliding() and !left_inner.is_colliding() \
		and !right_inner.is_colliding() and !right_outer.is_colliding():
			self.global_position.x = 5
