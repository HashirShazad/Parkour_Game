extends Node
# Variables <===========================================================================================>
# Levels <----------------------------------------------------------------------------------------->
var levels_UI = {
	main_menu = "res://Levels/Main_Menu.tscn",
	play_menu = "res://Levels/Play_Menu.tscn",
	settings_menu = "res://UI/Settings_Menu.tscn"
}

var levels_2P = {
	test = "res://Levels/TEST.tscn",
	l1 = "res://Levels/Level_1.tscn",
	l2 = "res://Levels/Level_2.tscn",
	l3 = "res://Levels/Level_3.tscn",
	l4 = "res://Levels/Level_4.tscn"
}

var levels_1P = {
	l1 = "res://Levels/Single_Player_Levels/Sp_Level_1.tscn"
}


# Mouse
var mouse_speed = 3
var mouse_pos = Vector2()
# Labels <----------------------------------------------------------------------------------------->
@onready var sec_label:Label = $Hud/Node/Timer_Info_Box/HBoxContainer/SecLabel
@onready var min_label:Label = $Hud/Node/Timer_Info_Box/HBoxContainer/MinLabel
@onready var msec_label:Label = $Hud/Node/Timer_Info_Box/HBoxContainer/MsecLabel
@onready var points_label:Label = $Hud/Node/Coin_Info_Box/PointsLabel
@onready var fps_label:Label = $Hud/Node/FPS_Info_Box/FPSLabel

# Menus <----------------------------------------------------------------------------------------->
@onready var pause_menu:CanvasLayer = $Pause_Menu
@onready var death_screen:CanvasLayer = $Death_Screen
@onready var hud = $Hud

#Player Refs <----------------------------------------------------------------------------------------->
var player_1:Player
var player_2:Player

@onready var crt:CanvasLayer = $CRT

# Info Boxes <----------------------------------------------------------------------------------------->
@onready var player1_info_box:Panel = $Hud/Node/Player_Info_Box
@onready var player2_info_box:Panel = $Hud/Node/Player2_Info_Box
@onready var coin_info_box:Panel = $Hud/Node/Coin_Info_Box


# Health Bars <----------------------------------------------------------------------------------------->
@onready var hp_bar_P1:ProgressBar = $Hud/Node/Player_Info_Box/Panel/ProgressBar
@onready var hp_bar_P2:ProgressBar = $Hud/Node/Player2_Info_Box/Panel/ProgressBar

# Timer <----------------------------------------------------------------------------------------->
var time:float
var time_sec:int
var time_msec:int
var time_min:int

# Miscellanous <----------------------------------------------------------------------------------------->
var points:int = 0
var paused:bool = false
var death_screen_shown:bool = false
var input_disabled:bool = false

var user_prefs:User_Preferences

# Actual Code <===========================================================================================>
func _ready():
	user_prefs = User_Preferences.load_or_create()
# Process just like event per tick
func _process(delta):
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	update_time(delta)
	handle_UI()
	if input_disabled:
		return
	if player_2 == null:
		if player_1:
			get_input()
			check_if_dead()
	elif player_1 && player_2:
		get_input()
		check_if_dead()
		
		
# Update user preference
# Show player 2 info box if player 2 exists only
func handle_UI():
	if player_2 != null:
		player2_info_box.show()
	else:
		player2_info_box.hide()
	if player_1 != null:
		player1_info_box.show()
	else:
		player1_info_box.hide()
		
# Pause the game if it is not paused and resume it if it is paused
func pause():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	else:
		pause_menu.show()
		pause_menu.grab_player_focus()
		Engine.time_scale = 0
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	paused = !paused
	
# Show death screen if it is not shown and hide it if it is shown
func _death_screen():
	if death_screen_shown:
		death_screen.hide()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	else:
		death_screen.show()
		death_screen.grab_player_focus()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	
	death_screen_shown = !death_screen_shown

# Add and upadate points
func add_points(collected_points:int) -> void:	
	points = points + collected_points
	points_label.text = "Points: " + str(points)

# Tween over health of players
func update_health():
	var tween = get_tree().create_tween()
	if player_1 != null:
		if "health" in player_1:
			tween.tween_property(hp_bar_P1, "value", player_1.health, .1).set_trans(Tween.TRANS_QUAD)
	if player_2 != null:
		if "health" in player_2:
			tween.tween_property(hp_bar_P2, "value", player_2.health, .1).set_trans(Tween.TRANS_QUAD)

# Update the timer
func update_time(delta):
	if player_1 == null:
		return
	time += delta
	time_msec = fmod(time, 1) * 100
	time_sec = fmod(time, 60)
	time_min = fmod(time, 3600) / 60
	min_label.text = "%02d:" % time_min
	sec_label.text = "%02d." % time_sec
	msec_label.text = "%03d" % time_msec

# Get input pressed by user
func get_input():
	if input_disabled:
		return
	if Input.is_action_just_pressed("Pause") && !death_screen_shown:
		pause()

# Check if p1 or p2 or both are dead and display death screen
func check_if_dead():
	# If player 2 exists
	if player_2:
		# If p2 dead follow p1
		if player_2.is_dead:
			player_2.position = player_1.position
		# If p1 dead follow p2
		if player_1.is_dead:
			player_1.position = player_2.position
		# If p1 and p2 dead show death screen
		if player_1.is_dead && player_2.is_dead:
			if death_screen_shown == false:
				_death_screen()
	# If player 2 does not exist and p1 is dead
	elif player_1.is_dead:
		if death_screen_shown == false:
			_death_screen()
	
# Gets input for mouse
func get_ui_input(delta):
	var mouse_rel = Vector2.ZERO
	if Input.is_action_pressed("Mouse_Up"):
		mouse_rel += Vector2.UP * mouse_speed
	elif Input.is_action_pressed("Mouse_Down"):
		mouse_rel += Vector2.DOWN * mouse_speed
	elif Input.is_action_pressed("Mouse_Left"):
		mouse_rel += Vector2.LEFT * mouse_speed
	elif Input.is_action_pressed("Mouse_Right"):
		mouse_rel += Vector2.RIGHT * mouse_speed
	if mouse_rel != Vector2.ZERO:
		DisplayServer.warp_mouse(mouse_pos + mouse_rel)
		#warp_mouse_position(mouse_pos + mouse_rel)
	#cursor.position = get_global_mouse_position()

# Set all the variables back to their original values
func restart():
	# Timer
	time = 0
	min_label.text = "00:" 
	sec_label.text = "00."
	msec_label.text = "000"
	# Points
	points = 0
	points_label.text = "Points: 0"
	# Health
	if player_1 != null:
		player_1.health = 100
	if player_2 != null:
		player_2.health = 100
	update_health()

func set_saved_level(level):
	
	if user_prefs:
		user_prefs.saved_level = level
		user_prefs.save()



# Transparent UI <----------------------------------------------------------------------------------------->
# Buttons <----------------------------------------------------------------------------------------->

# Single Player Button
func _on_sp_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_1P.l1)
	await  Transitioner.transition_fully_finished
	input_disabled = false
	update_health()

# Two Player Button
func _on_2p_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_2P.l1)
	await  Transitioner.transition_fully_finished
	input_disabled = false
	update_health()
# Test Level Button
func _on_test_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_2P.test)
	await  Transitioner.transition_fully_finished
	input_disabled = false

# Back to main menu button from settings and play menu
func _on_back_to_main_menu_button_pressed():
	if input_disabled:
		return
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.main_menu)
	await Transitioner.transition_fully_finished
	input_disabled = false

# settings button
func _on_settings_button_pressed():
	if input_disabled:
		return
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.settings_menu)
	input_disabled = false

# Death Screen retry button
func _on_retry_button_pressed():
	#Death_Screen button
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	input_disabled = true
	restart()
	update_health()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	_death_screen()
	await Transitioner.transition_fully_finished
	input_disabled = false
	
# Play button
func _on_play_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.play_menu)
	await  Transitioner.transition_fully_finished
	input_disabled = false

# Game Quit/Close button
func _on_close_button_pressed():
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().quit()

# Game resume button
func _on_resume_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	pause()

# Game back to main menu when paused button
func _on_back_button_pressed():
	set_saved_level(get_tree().current_scene.scene_file_path)
	user_prefs.points = points
	restart()
	player_1 = null
	player_2 = null
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	pause()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.main_menu)

# Restart Pause menu button
func _on_restart_button_pressed():
	# Hide mouse and disable input
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	input_disabled = true
	restart()
	death_screen_shown = false
	update_health()
	pause()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	await Transitioner.transition_fully_finished
	input_disabled = false

# Game back to main menu of death_screen
func _on_back_button_death_screen_pressed():
	set_saved_level(get_tree().current_scene.scene_file_path)
	restart()
	player_1 = null
	player_2 = null
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.main_menu)
	if death_screen_shown:
		_death_screen()

# Load button
func _on_load_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	if user_prefs:
		if user_prefs.saved_level != null:
			print(user_prefs.saved_level)
			get_tree().change_scene_to_file(user_prefs.saved_level)
	await  Transitioner.transition_fully_finished
	input_disabled = false

#CRT BUTTON
func _on_crt_btn_toggled(toggled_on):
	crt.visible = toggled_on
