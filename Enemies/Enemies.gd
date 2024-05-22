extends Entity
class_name Enemy
# Variables <===============================================================================================>
# Scenes <----------------------------------------------------------------------------------------->
var ghost_scene = preload("res://Character/Ghost.tscn")
var jump_sound = preload("res://Sounds/Sound/Jump.wav")

# Edge Checks <----------------------------------------------------------------------------------------->
@onready var edge_check_right:RayCast2D = $Edge_Check_Right
@onready var edge_check_left:RayCast2D = $Edge_Check_Left

# Actual Code <===============================================================================================>
func _ready():
	health = max_health
	if randf_range(-1, 1) > 0:
		direction = 1
	else:
		direction = -1
		
func _physics_process(delta):
	flip_sprite()
	if sprite_2d:
		update_animation(sprite_2d)
	if silhouette_sprite:
		update_animation(silhouette_sprite)
	var found_wall = is_on_wall()
	if edge_check_left and edge_check_right:
		var found_edge = not edge_check_right.is_colliding() or not  edge_check_left.is_colliding()
		if found_wall or found_edge:
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
				
				

func add_ghost():
	var ghost = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.play(sprite_2d.animation)
	ghost.flip_h = sprite_2d.flip_h
	ghost.sprite_2d.frame = sprite_2d.frame

func flip_sprite():
	if sprite_2d == null:
		return
	if is_stunned || is_dead:
		return
	if velocity.x != 0:
		if velocity.x > 1:
			sprite_2d.flip_h = 1
		if velocity.x < -1:
			sprite_2d.flip_h = 0
