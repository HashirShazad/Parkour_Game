extends StaticBody2D

@onready var position_to_move = $"../Position_To_Move"

var buttons:Array

var is_opened:bool = false
func _ready():
	var children := get_parent().get_children()
	for child in children:
		if child.is_in_group("Button"):
			buttons.append(child)
	
func _process(delta):
	if buttons == null:
		return
	if is_opened == true:
		return
	for button in buttons:
		if "is_on" in button:
			if button.is_on == false:
				return
	if position_to_move:
		var tween:Tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUART) 
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self,"position",position_to_move.position,0.5)
		is_opened = true
