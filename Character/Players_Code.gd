extends CharacterBody2D
class_name Player

var push_force = 80.0
var health:int = 100
var max_health:int = 100
var is_pushing:bool = 0

var def_speed:int = 400
var def_jump_velocity:int = -800
var def_minimum_speed:int = 8
var def_push_force = 80.0

var sprint_speed:int = 600
var sprint_minimum_speed:int = 12
var sprint_jump_velocity:int = -600
var sprint_push_force = 160.0



var jump_count:int = 0
@export var btns = {
	 Right = "P1_Right",
	 Left = "P1_Left",
	 Jump = "P1_Jump",
	 Sprint = "P1_Sprint",
}

@export var animations = {
	 Idle = "Frog_Idle",
	 Jumping = "Frog_Jumping",
	 Falling = "Frog_Falling",
	 Walking = "Frog_Walking",
	 Double_Jump = "Frog_Double_Jump"
}

var speed = 400.0
var minimum_speed = 8
var jump_velocity = -800.0

@onready var sprite_2d = $AnimatedSprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

		
func _physics_process(delta):
	flip_sprite()
	update_animation()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity  * delta
	elif jump_count != 0:
		jump_count = 0
	# Handle jump.
	if Input.is_action_just_pressed(btns.Jump) and jump_count < 2:
		jump_count = jump_count + 1
		velocity.y = jump_velocity
		
	if Input.is_action_pressed(btns.Sprint):
		$CPUParticles2D.emitting = 1
		speed = sprint_speed
		jump_velocity = sprint_jump_velocity
		minimum_speed = sprint_minimum_speed
		push_force = sprint_push_force
	elif Input.is_action_just_released(btns.Sprint):
		$CPUParticles2D.emitting = 0
		speed = def_speed
		jump_velocity = def_jump_velocity
		minimum_speed = def_minimum_speed
		push_force = def_push_force
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(btns.Left, btns.Right)
	if direction:
		velocity.x = direction * speed
	else:
		# move_toward(speed
		velocity.x = move_toward(velocity.x, 0, minimum_speed)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			is_pushing = 1
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		else:
			is_pushing = 0
				
func update_animation():
	if velocity.y < 0:
		if jump_count < 2:
			sprite_2d.play(animations.Jumping)
		else:
			sprite_2d.play(animations.Double_Jump)
	elif velocity.y > 0:
		if jump_count < 2:
			sprite_2d.play(animations.Falling)
		else:
			sprite_2d.play(animations.Double_Jump)
	elif velocity.x != 0 || is_pushing:
		sprite_2d.play(animations.Walking)
	elif velocity.x == 0:
		sprite_2d.play(animations.Idle)
	
func flip_sprite():
	if velocity.x != 0:
		if velocity.x > 1:
			sprite_2d.flip_h = 0
		if velocity.x < -1:
			sprite_2d.flip_h = 1


