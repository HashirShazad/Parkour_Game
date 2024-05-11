extends Area2D

@export var target_scene:PackedScene
@onready var animated_sprite_2d = $AnimatedSprite2D
	
func _on_body_entered(body):
	if body.is_in_group("Players"):
		
		Transitioner.start_transition()
		animated_sprite_2d.play("Collected")
		GameManger.input_disabled = true
		GameManger.timer_stopped = true
		await Transitioner.transiton_finsihed
		get_tree().change_scene_to_packed(target_scene)
		GameManger.timer_stopped=false
		GameManger.update_health()
		GameManger.input_disabled = false
