extends CharacterBody2D
class_name Entity

# Variables <=====================================================================================>
# Stats <----------------------------------------------------------------------------------------->
var push_force = 80.0
## Current health of the entity. If it is 0 or less than the object is killed.
@export var health:int = 100
var max_health:int = 100
var jump_count:int = 0

# Directions <----------------------------------------------------------------------------------------->
var direction:float
var kb_direction:Vector2

# Booleans <----------------------------------------------------------------------------------------->
var is_pushing:bool = 0
var is_dead:bool = 0
var is_stunned:bool = 0
var on_ground:bool = 0
var is_respawning:bool = 0

# Default Speed <----------------------------------------------------------------------------------------->
var def_speed:int = 400
var def_jump_velocity:int = -800
var def_minimum_speed:int = 8
var def_push_force = 80.0

# Sprint Speed <----------------------------------------------------------------------------------------->
const sprint_speed:int = 600
const sprint_minimum_speed:int = 12
const sprint_jump_velocity:int = -600
const sprint_push_force = 160.0

# Squash and Stretch <------------------------------------------------------------------------->
var squashed_size:Vector2 = Vector2(1.1, 0.8) 
var stretched_size:Vector2 = Vector2(0.8, 1.1)

## Animations to be played
@export_group("Animations", "ani_")
@export var ani_idle := "Frog_Idle"
@export var ani_jumping := "Frog_Jumping"
@export var ani_falling := "Frog_Falling"
@export var ani_walking := "Frog_Walking"
@export var ani_double_jump := "Frog_Double_Jump"
@export var ani_damaged := "Frog_Damaged"
@export var ani_dead := "Dead"
@export var ani_spawn := "Spawn"


# Used Speed Variables <--------------------------------------------------------------------------------->
var speed = 400.0
var minimum_speed = 8
var jump_velocity = -800.0

# References <----------------------------------------------------------------------------------------->
@export_group("Sprites")
@export var sprite_2d:AnimatedSprite2D
@export var silhouette_sprite:AnimatedSprite2D
@export_group("Collision Shapes")
@export var hurt_box:CollisionShape2D
@export var collision_shape_2d:CollisionShape2D
@export_group("Particles")
@export var dust_particles:CPUParticles2D

# Gravity <----------------------------------------------------------------------------------------->
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Actual Code <=====================================================================================>
func _physics_process(delta):
	
	if silhouette_sprite:
		update_animation(silhouette_sprite)
		flip_sprite(silhouette_sprite)
	if sprite_2d:
		update_animation(sprite_2d)
		flip_sprite(sprite_2d)
	if is_dead:
		return

		
	elif jump_count != 0:
		jump_count = 0
	# Handle jump.

	move_and_slide()
	check_collisions()
	
# Update animations based on conditions
func update_animation(sprite:AnimatedSprite2D):
	if sprite != null:
		if is_respawning:
			sprite.play(ani_spawn)
		if is_dead:
			sprite.play(ani_dead)
		elif is_stunned:
			sprite.play(ani_damaged)
		elif velocity.y < 0:
			kb_direction.y = -1
			if jump_count < 2:
				sprite.play(ani_jumping)
			else:
				sprite.play(ani_double_jump)
		elif velocity.y > 0:
			kb_direction.y = 1
			if jump_count < 2:
				sprite.play(ani_falling)
			else:
				sprite.play(ani_double_jump)
		elif velocity.x != 0 || is_pushing:
			sprite.play(ani_walking)
		elif velocity.x == 0:
			sprite.play(ani_idle)
	
# Flip the sprite horizontally
func flip_sprite(sprite):
	if sprite == null:
		return
	if is_stunned || is_dead:
		return
	if velocity.x != 0:
		if velocity.x > 1:
			sprite.flip_h = 0
		if velocity.x < -1:
			sprite.flip_h = 1

# Take Damage and stun
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

# Take knock back
func take_knockback(strength:Vector2, direction:Vector2):
	var str_y_const = 1
	if is_dead:
		return
	if is_stunned:
		return
	pass
	velocity.x = 0
	if direction.x != 0:
		str_y_const = 1
		velocity.x = strength.x * direction.x
	else:
		str_y_const = 2
		velocity.x = strength.x * -kb_direction.x
	if is_on_floor():
		velocity.y = -1 * strength.y  * str_y_const
	else:
		if direction.y != 0:
			velocity.y = direction.y * strength.y * str_y_const
		else:
			velocity.y = strength.y * -kb_direction.y
	
# Check if it is colliding with rigid bodies
func check_collisions():
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			is_pushing = 1
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		else:
			is_pushing = 0

# Squash on land for cute effects :)
func squash():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale",squashed_size, .1).set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(silhouette_sprite, "scale",squashed_size, .1).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(squash_and_stretch_finished)

# Strectch on jump for cute effects :)
func stretch():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale",stretched_size, .1).set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(silhouette_sprite, "scale",stretched_size, .1).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(squash_and_stretch_finished)

# Return character to original state after squas and strectch are finsihed
func squash_and_stretch_finished():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "scale",Vector2(1,1), .1).set_trans(Tween.TRANS_QUAD)
	#tween.tween_property(silhouette_sprite, "scale",Vector2(1,1), .1).set_trans(Tween.TRANS_QUAD)
	
