extends Node

@onready var points_label = $Hud/Node/Coin_Info_Box/PointsLabel
@onready var pause_menu = $Pause_Menu


var points = 0
var paused:bool = false

func _process(delta):
	print(paused)
	if Input.is_action_just_pressed("Pause"):
		pause()
		
func pause():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
	
func add_points(collected_points:int) -> void:
	points = points + collected_points
	print(points)
	points_label.text = "Points: " + str(points)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")


func _on_close_button_pressed():
	get_tree().quit()


func _on_resume_button_pressed():
	pause()


func _on_back_button_pressed():
	pause()
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")


func _on_restart_button_pressed():
	pause()
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
