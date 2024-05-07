extends Node

## Music to be played when the level starts
@export var main_menu_music = preload
("res://Sounds/BG_Music/Albeniz Asturias-1sdsfVcxpC0-192k-1708856808.mp3")


func _ready():
	AudioPlayer.play_music(main_menu_music)
	if self.name == "MainMenu":
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


