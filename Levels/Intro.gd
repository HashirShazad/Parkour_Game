extends Node2D

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)

func _on_animation_player_animation_finished(anim_name):
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")
