extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	name = str(get_multiplayer_authority())
	text = str(name)
