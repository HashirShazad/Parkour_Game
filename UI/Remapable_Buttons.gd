extends Button
class_name Remap_Button
# Variables <=====================================================================================>
@export var action:String


# Actual Code <=====================================================================================>

# When created
func _init():
	toggle_mode = true
	theme_type_variation = "Remap_Button"

# On ready
func _ready():
	set_process_unhandled_input(false)
	update_key_text()

# On clicked
func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "..."
		release_focus()
	else:
		update_key_text()
		grab_focus()
		
# Input
func _unhandled_input(event):
	if event.pressed: 
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		

# Set text of button
func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
