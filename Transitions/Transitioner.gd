extends CanvasLayer
signal transiton_finsihed
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_transition():
	color_rect.show()
	animation_player.play("fade_in")


func _on_animation_player_animation_finished(anim_name):

	if anim_name == "fade_in":
		transiton_finsihed.emit()
		animation_player.play("fade_out")
	elif anim_name == "fade_out":
		color_rect.hide()
