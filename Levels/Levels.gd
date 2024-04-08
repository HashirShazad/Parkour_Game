extends Node
@export var music = preload("res://Sounds/BG_Music/Hollow Knight OST - Mantis Lords.wav")


func _ready():
	AudioPlayer.play_music(music)
	if self.name == "MainMenu":
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
