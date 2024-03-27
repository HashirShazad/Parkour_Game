extends Area2D

@export var target_scene:PackedScene

func _on_body_entered(body):
	if(body.name == "Player1" || body.name == "Player2"):
		get_tree().change_scene_to_packed(target_scene)
