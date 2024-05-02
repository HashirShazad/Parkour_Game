extends Node2D
# Variables <===============================================================================================>
@export var main_menu_music = preload
("res://Sounds/BG_Music/Albeniz Asturias-1sdsfVcxpC0-192k-1708856808.mp3")
var user_prefs:User_Preferences

# Actual Code <===============================================================================================>
func _ready():
	# Hide the mouse and play the music
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	AudioPlayer.play_music(main_menu_music)
	user_prefs = User_Preferences.load_or_create()
	set_res()
	set_sound_level()
	set_controls()
	
	
func _on_animation_player_animation_finished(anim_name):
	# When animation finished change to main menu
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")
	
func set_res() -> void:
	if !user_prefs:
		return
	DisplayServer.window_set_size(user_prefs.resolution)
	DisplayServer.window_set_mode(user_prefs.window_mode)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, user_prefs.is_borderless)

func set_sound_level():
	var music_value:float = user_prefs.music_value 
	var master_value:float = user_prefs.master_value 
	var sfx_value:float = user_prefs.sfx_value
	# 0 is master 1 is music 2 is SFX
	AudioServer.set_bus_volume_db(0, linear_to_db(master_value))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_value))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_value))

func set_controls():
	if !user_prefs:
		return
		
	for action in user_prefs.action_events:
		if user_prefs.action_events.has(action):
			var event = user_prefs.action_events[action]
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
