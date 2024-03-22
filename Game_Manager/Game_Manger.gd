extends Node

@onready var points_label = $"../UI/Panel/PointsLabel"

var points = 0

func add_points(collected_points:int) -> void:
	points = points + collected_points
	print(points)
	points_label.text = "Points:" + str(points)
