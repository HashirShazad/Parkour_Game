extends Button
class_name Remap_Button

@export var action:String

func _init():
	toggle_mode = true
	theme_type_variation = "Remap_Button"

func _ready():
	set_process_unhandled_input(false)
	update_key_text()

func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		
func _unhandled_input(event):
	if event.pressed: 
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = 0
		
		
func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
