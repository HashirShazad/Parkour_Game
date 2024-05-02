extends Control
class_name Audio_Slider

@onready var audio_name_label:Label = $Music/Label
@onready var h_slider:HSlider = $Music/HSlider
@onready var value_label:Label = $Music/Value


var user_prefs:User_Preferences

@export_enum("Master", "Music", "SFX") var bus_name:String
@onready var bus_index:int = AudioServer.get_bus_index(bus_name)
# Called when the node enters the scene tree for the first time.
func _ready():
	user_prefs = User_Preferences.load_or_create()
	h_slider.value_changed.connect(_on_h_slider_changed)
	set_name_label()
	load_save()
	
func load_save():
	
	match bus_index:
		0:# Master
			h_slider.value = user_prefs.master_value
		1:# Music
			h_slider.value = user_prefs.music_value
		2:# SFX
			h_slider.value = user_prefs.sfx_value

func _on_h_slider_changed(value:int) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_value_label()
	save()

func set_name_label() -> void:
	audio_name_label.text = str(bus_name)

func set_value_label() -> void:
	value_label.text = str(h_slider.value)

func save():
	if !user_prefs:
		return
	match bus_index:
		0:# Master
			user_prefs.master_value = h_slider.value 
		1:# Music
			user_prefs.music_value = h_slider.value 
		2:# SFX
			user_prefs.sfx_value = h_slider.value
			
	user_prefs.save()
