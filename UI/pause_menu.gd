extends CanvasLayer
@onready var resume_button = $Panel/Buttons/Play_Panel/Play/Resume_Button


	
func grab_player_focus():
	resume_button.grab_focus()
