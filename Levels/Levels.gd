extends Node
@export var music = preload("res://Sounds/BG_Music/Hollow Knight OST - Mantis Lords.wav")


func _ready():
	AudioPlayer.play_music(music)
