extends Node2D

@onready var resolution_option_button:OptionButton = $CanvasLayer/BG/Controls/TabContainer/Settings/Resolution_Container/OptionButton
@onready var window_mode_option_button:OptionButton = $CanvasLayer/BG/Controls/TabContainer/Settings/Window_Mode_Container/OptionButton
@onready var borderless_button:CheckButton = $CanvasLayer/BG/Controls/TabContainer/Settings/Window_Mode_Container2/CheckButton

var user_prefs:User_Preferences
var stored_res:Vector2i
const WINDOW_MODES:Array[String] = [
	"Window Mode",
	"Full-Screen",
]
const RESOLUTION_MODES:Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
	"1920 x 1200" : Vector2i(1920, 1200)
}


func _ready():
	user_prefs = User_Preferences.load_or_create()
	# Add Items
	add_option_items()
	
	get_current_res_and_apply()
	
	window_mode_option_button.item_selected.connect(_on_window_mode_selected)
	resolution_option_button.item_selected.connect(_on_resolution_selected)
	
	
func add_option_items() -> void:
	add_window_mode_items()
	add_resolution_mode_items()
	

func add_window_mode_items() ->  void:
	for window_mode in WINDOW_MODES:
		window_mode_option_button.add_item(window_mode)
		
func add_resolution_mode_items() ->  void:
	for resolution_mode in RESOLUTION_MODES:
		resolution_option_button.add_item(resolution_mode)
	resolution_option_button.selected = 3

func _on_window_mode_selected(index : int):
	match index:
		0:#Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			if stored_res:
				DisplayServer.window_set_size(stored_res)
		1:#Full screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	save()

func _on_resolution_selected(index : int):
	if DisplayServer.window_get_mode() == 3: # 3 is fullscreen while 1 is windowed
		stored_res = RESOLUTION_MODES.values()[index]
	DisplayServer.window_set_size(RESOLUTION_MODES.values()[index])
	save()

func save() -> void:
	if !user_prefs:
		return
	user_prefs.resolution = DisplayServer.window_get_size()
	user_prefs.window_mode = DisplayServer.window_get_mode()
	user_prefs.is_borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	user_prefs.save()

func get_current_res_and_apply() -> void:
	if !user_prefs:
		return
		
	var res = user_prefs.resolution
	print(res)
	var win_mode = DisplayServer.window_get_mode()
	var res_index = RESOLUTION_MODES.values().find(res)
	var win_mode_index = win_mode
	
	if win_mode_index == 1:
		window_mode_option_button.selected = 0
	elif win_mode_index == 3:
		window_mode_option_button.selected = 1
		
	resolution_option_button.selected = res_index
	borderless_button.button_pressed = user_prefs.is_borderless

func _on_check_button_toggled(toggled_on):
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
	save()
