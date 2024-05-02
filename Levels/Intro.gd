extends Node2D
# Variables <===============================================================================================>
@export var main_menu_music = preload
("res://Sounds/BG_Music/Beethoven Virus (Insane Piano Version).wav")
var user_prefs:User_Preferences

# Actual Code <===============================================================================================>
func _ready():
	# Hide the mouse and play the music
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	AudioPlayer.play_music(main_menu_music)
	user_prefs = User_Preferences.load_or_create()
	set_res()
	
	
func _on_animation_player_animation_finished(anim_name):
	# When animation finished change to main menu
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")
	
func set_res() -> void:
	if !user_prefs:
		return
	print(user_prefs.resolution)
	DisplayServer.window_set_size(user_prefs.resolution)
	DisplayServer.window_set_mode(user_prefs.window_mode)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, user_prefs.is_borderless)
