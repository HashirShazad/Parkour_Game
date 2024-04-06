extends Label
class_name Button_Label

@export var action:String
func _ready():
	text = "%s" + % InputMap.action_get_events(action)[0].as_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
