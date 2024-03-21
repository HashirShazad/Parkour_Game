extends CharacterBody2D
class_name Player


var def_speed = 400
var def_jump_velocity = -800
var sprint_speed = 600
var sprint_jump_velocity = -400

@export btns{
	 Right:Button = P
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

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_pressed("Sprint"):
		$CPUParticles2D.emitting = 1
		speed = sprint_speed
		jump_velocity = sprint_jump_velocity
	elif Input.is_action_just_released("Sprint"):
		$CPUParticles2D.emitting = 0
		speed = def_speed
		jump_velocity = def_jump_velocity
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		# move_toward(speed
		velocity.x = move_toward(velocity.x, 0, minimum_speed)

	move_and_slide()
	
func update_animation():
	if velocity.y < -1:
		sprite_2d.play("Jumping")
	elif velocity.y > 1:
		sprite_2d.play("Falling")
	elif velocity.x != 0:
		sprite_2d.play("Walking")
	elif velocity.x == 0:
		sprite_2d.play("Idle")
	
	
func flip_sprite():
	if velocity.x != 0:
		if velocity.x > 1:
			sprite_2d.flip_h = 0
		if velocity.x < -1:
			sprite_2d.flip_h = 1
