extends Node
@export var main_menu_music = preload
("res://Sounds/BG_Music/Beethoven Virus (Insane Piano Version).wav")


func _ready():
	AudioPlayer.play_music(main_menu_music)
	if self.name == "MainMenu":
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)


