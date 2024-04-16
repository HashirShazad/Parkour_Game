extends Interactables
class_name Lever

# Variables <=====================================================================================>
@onready var sprite_2d = $Sprite2D
@onready var effects = $CPUParticles2D

@export var animations = {
	default = "On",
	pressed = "Off" 
}
# Actual Code <============================================================================================>


# On body entered
func _on_area_2d_body_entered(body):
	effects.emitting = 1
	if body.velocity.x < -1:
		is_on = true
		sprite_2d.play(animations.pressed)
	elif body.velocity.x > 1:
		is_on = false
		sprite_2d.play(animations.default)
	
