extends CanvasLayer

@onready var retry_button = $Panel/Buttons/Settings_Panel/Settings/Retry_Button



func grab_player_focus():
	retry_button.grab_focus()
