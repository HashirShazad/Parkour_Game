extends Area2D

@export var target_scene:PackedScene
@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_body_entered(body):
	if(body.name == "Player1" || body.name == "Player2"):
		
		Transitioner.start_transition()
		animated_sprite_2d.play("Collected")
		await Transitioner.transiton_finsihed
		get_tree().change_scene_to_packed(target_scene)
