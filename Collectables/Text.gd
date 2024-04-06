extends Area2D

@onready var label = $Label


func _on_body_entered(body):
	if body.is_in_group("Players"):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUART) 
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(label,"modulate:a",1,0.5)

func _on_body_exited(body):
	if body.is_in_group("Players"):
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUART) 
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(label,"modulate:a",0,0.5)
