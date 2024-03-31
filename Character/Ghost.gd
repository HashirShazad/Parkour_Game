extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween:Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART) 
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate:a",0.0,0.5)
	tween.tween_callback(finished)

func finished():
	queue_free()
