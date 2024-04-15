extends Node2D
# Variables <===============================================================================================>
@export var main_menu_music = preload
("res://Sounds/BG_Music/Beethoven Virus (Insane Piano Version).wav")

# Actual Code <===============================================================================================>
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	AudioPlayer.play_music(main_menu_music)
	
func _on_animation_player_animation_finished(anim_name):
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")
