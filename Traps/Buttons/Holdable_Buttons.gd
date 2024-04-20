extends Interactables
class_name Holdable_Buttons


signal button_pressed(is_on)
# Variables <=====================================================================================>
@onready var sprite_2d = $Sprite2D

@export var animations = {
	default = "default_red",
	pressed = "pressed_red" 
}
# Actual Code <============================================================================================>

func _ready():
	sprite_2d.play(animations.default)
# On body entered
func _on_area_2d_body_entered(body):
	is_on = true
	sprite_2d.play(animations.pressed)
	button_pressed.emit(is_on)
	
# On body exited
func _on_area_2d_body_exited(body):
	is_on = false
	sprite_2d.play(animations.default)
	button_pressed.emit(is_on)
