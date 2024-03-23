extends Node


@onready var points_label = $"../UI/Node/Coin_Info_Box/PointsLabel"

var points = 0

func add_points(collected_points:int) -> void:
	points = points + collected_points
	print(points)
	points_label.text = "Points: " + str(points)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")


func _on_back_button_pressed():
	get_tree().quit()
