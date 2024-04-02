extends CharacterBody2D

class_name Entity

var push_force = 80.0
var health:int = 100
var max_health:int = 100

var direction:float


var is_pushing:bool = 0
var is_dead:bool = 0
var is_stunned:bool = 0
var on_ground:bool = 0


var def_speed:int = 400
var def_jump_velocity:int = -800
var def_minimum_speed:int = 8
var def_push_force = 80.0

var sprint_speed:int = 600
var sprint_minimum_speed:int = 12
var sprint_jump_velocity:int = -600
var sprint_push_force = 160.0

var jump_count:int = 0


@export var animations = {
	 Idle = "Frog_Idle",
	 Jumping = "Frog_Jumping",
	 Falling = "Frog_Falling",
	 Walking = "Frog_Walking",
	 Double_Jump = "Frog_Double_Jump",
	 Damaged = "Frog_Damaged",
	 Dead = "Dead"
}
var speed = 400.0
var minimum_speed = 8
var jump_velocity = -800.0

@onready var sprite_2d = $AnimatedSprite2D
@onready var hurt_box = $Hurt_Box/CollisionShape2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var dust_particles = $Dust_Particles

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
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

	move_and_slide()
	check_collisions()
	
	
func update_animation():
	if is_dead:
		sprite_2d.play(animations.Dead)
	elif is_stunned:
		sprite_2d.play(animations.Damaged)
	elif velocity.y < 0:
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
	if is_stunned || is_dead:
		return
	if velocity.x != 0:
		if velocity.x > 1:
			sprite_2d.flip_h = 0
		if velocity.x < -1:
			sprite_2d.flip_h = 1

func take_damage(damage:int, stun_duration:float):
	if is_dead:
		return
	if is_stunned:
		return
	health -= damage
	is_stunned = 1
	
	if health <= 0:
		is_dead = true
		hurt_box.set_deferred("disabled", true)
		collision_shape_2d.set_deferred("disabled", true)
		await get_tree().create_timer(.25).timeout
		
		sprite_2d.hide()
		
	await get_tree().create_timer(stun_duration).timeout
	is_stunned = 0

func take_knockback(kb_direction: Vector2, strength:Vector2):
	if is_dead:
		return
	if is_stunned:
		return
	pass
	velocity.x = 0
	velocity.x = kb_direction.x * strength.x
	velocity.y = kb_direction.y * strength.y
	
func check_collisions():
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			is_pushing = 1
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		else:
			is_pushing = 0
