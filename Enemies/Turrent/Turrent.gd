extends Node2D
class_name Turrent

# Variables <===================================================================================>
@onready var sprite_2d = $Sprite2D
var target
@onready var ray_cast_2d = $RayCast2D
@onready var reload_timer = $RayCast2D/Reload_Timer

@export var BULLET:PackedScene




# Code <===================================================================================>
func _ready():
	await(get_tree().process_frame)
	target = find_target()


func _physics_process(delta):
	target = find_target()
	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		ray_cast_2d.rotation = angle_to_target
		
		if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider().is_in_group("Players"):
			sprite_2d.rotation = angle_to_target
			if reload_timer.is_stopped():
				shoot()
		 
# Finds the nearest player
func find_target():
	var new_target
	var new_target_distance 
	var prev_target_distance = 1000000000
	var players
	if get_tree().has_group("Players"):
		players = get_tree().get_nodes_in_group("Players")
	# Get all players
	for player in players:
		# If they have a property position
		if "global_position" in player:
			# Get distance from self to player
			new_target_distance = position.distance_to(players.position)
			# If distance is less than the previous target distance
			if new_target_distance < prev_target_distance:
				# New target is the player and the previous target distance is the new target distance
				new_target = player
				prev_target_distance = new_target_distance
	# Return the target
	return new_target

func shoot():
	ray_cast_2d.enabled = false
	if BULLET:
		var bullet = BULLET.instantiate()
		add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = sprite_2d.global_rotation
	reload_timer.start()


func _on_reload_timer_timeout():
	ray_cast_2d.enabled = true
