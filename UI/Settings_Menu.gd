extends Node2D

@onready var resolution_option_button:OptionButton = $CanvasLayer/BG/Controls/TabContainer/Settings/Resolution_Container/OptionButton
@onready var window_mode_option_button:OptionButton = $CanvasLayer/BG/Controls/TabContainer/Settings/Window_Mode_Container/OptionButton
var user_prefs:User_Preferences

const WINDOW_MODES:Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]

const RESOLUTION_MODES:Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
	"1920 x 1200" : Vector2i(1920, 1200)
}


func _ready():
	get_current_res_and_apply()
	user_prefs = User_Preferences.load_or_create()
	add_window_mode_items()
	add_resolution_mode_items()
	window_mode_option_button.item_selected.connect(_on_window_mode_selected)
	resolution_option_button.item_selected.connect(_on_resolution_selected)
	
func add_window_mode_items() ->  void:
	for window_mode in WINDOW_MODES:
		window_mode_option_button.add_item(window_mode)
		
func add_resolution_mode_items() ->  void:
	for resolution_mode in RESOLUTION_MODES:
		resolution_option_button.add_item(resolution_mode)

func _on_window_mode_selected(index : int):
	match index:
		0:# Full screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:#Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:#Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:#Borderless Full screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	
	save()

func _on_resolution_selected(index : int):
	DisplayServer.window_set_size(RESOLUTION_MODES.values()[index])
	save()

func save() -> void:
	if !user_prefs:
		return
	user_prefs.resolution = DisplayServer.window_get_size()
	user_prefs.window_mode = DisplayServer.window_get_mode()

func get_current_res_and_apply() -> void:
	var res = DisplayServer.window_get_size()
	var win_mode = DisplayServer.window_get_mode()
	var res_index = RESOLUTION_MODES.values().find(res)
	var win_mode_index = WINDOW_MODES.find(win_mode)
	resolution_option_button.selected = res_index
	window_mode_option_button.selected = win_mode_index
