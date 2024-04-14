extends Node
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

@onready var timer_label = $Hud/Node/Timer_Info_Box/TimerLabel
@onready var points_label = $Hud/Node/Coin_Info_Box/PointsLabel
@onready var pause_menu = $Pause_Menu
@onready var death_screen = $Death_Screen

var player_1
var player_2
var camera

var input_disabled:bool = false
var is_single_player:bool = true


@onready var player1_info_box = $Hud/Node/Player_Info_Box
@onready var player2_info_box = $Hud/Node/Player2_Info_Box
@onready var coin_info_box = $Hud/Node/Coin_Info_Box

@onready var hp_bar_P1 = $Hud/Node/Player_Info_Box/Panel/ProgressBar
@onready var hp_bar_P2 = $Hud/Node/Player2_Info_Box/Panel/ProgressBar


var time:float
var time_sec:int
var time_msec:int
var time_min:int

var points = 0
var paused:bool = false
var death_screen_shown:bool = false

func _ready():
	apply_single_player_rules()

func _process(delta):
	#update_time(delta)
	if input_disabled:
		return
	if is_single_player:
		if player_1:
			get_input()
			check_if_dead()
	elif player_1 && player_2:
		get_input()
		check_if_dead()
		
func pause():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	else:
		pause_menu.show()
		Engine.time_scale = 0
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	paused = !paused
	
func _death_screen():
	if death_screen_shown:
		death_screen.hide()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	else:
		death_screen.show()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	
	death_screen_shown = !death_screen_shown

func add_points(collected_points:int) -> void:	
	points = points + collected_points
	points_label.text = "Points: " + str(points)

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

func _on_close_button_pressed():
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	get_tree().quit()

func _on_resume_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	pause()

func _on_back_button_pressed():
	player_1 = null
	player_2 = null
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	pause()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.main_menu)

func _on_restart_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	# Pause menu button
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

func update_health():
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar_P1, "value", player_1.health, .1).set_trans(Tween.TRANS_QUAD)
	if !is_single_player:
		tween.tween_property(hp_bar_P2, "value", player_2.health, .1).set_trans(Tween.TRANS_QUAD)
	
func _on_back_to_main_menu_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.main_menu)

func _on_settings_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_UI.settings_menu)

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
	
func update_time(delta):
	time += delta
	time_msec = fmod(time, 1) * 100
	time_sec = fmod(time, 60)
	time_min = fmod(time, 3600) / 60
	timer_label.text = "Timer: " + str(time_min) + "." + str(time_sec) + "."+ str(time_msec) 

func get_input():
	if Input.is_action_just_pressed("Pause") && !death_screen_shown:
		pause()
	if Input.is_action_just_pressed("Restart") && paused:
		_on_restart_button_pressed()
	if Input.is_action_just_pressed("Restart") && death_screen_shown:
		_on_retry_button_pressed()

func check_if_dead():
	if player_1.is_dead:
		player_1.position = player_2.position
		if is_single_player:
			if death_screen_shown == false:
				_death_screen()
	if !is_single_player:
		if player_2.is_dead:
			player_2.position = player_1.position

		if player_1.is_dead && player_2.is_dead:
			if death_screen_shown == false:
				_death_screen()

func update_ui_alpha(value:float = .5):
	var tween = get_tree().create_tween()
	tween.tween_property(player1_info_box, "modulate:a", value, .1).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player2_info_box, "modulate:a", value, .1).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(coin_info_box, "modulate:a", value, .1).set_trans(Tween.TRANS_QUAD)

func _on_area_2d_body_entered(body):
	update_ui_alpha(.1)

func _on_area_2d_body_exited(body):
	update_ui_alpha(1)

func apply_single_player_rules():
	if is_single_player:
		player2_info_box.hide()
		print("HIDDEN")
	else:
		player2_info_box.visible = true
		player2_info_box.show()
		print("SHOWED")

func _on_sp_button_pressed():
	is_single_player = true
	print("HAHA" , is_single_player)
	apply_single_player_rules()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_1P.l1)
	await  Transitioner.transition_fully_finished
	input_disabled = false

func _on_2p_button_pressed():
	is_single_player = false
	print("HAHA" , is_single_player)
	apply_single_player_rules()
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	if input_disabled:
		return
	Transitioner.start_transition()
	input_disabled = true
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(levels_2P.l1)
	await  Transitioner.transition_fully_finished
	input_disabled = false
	is_single_player = false
	print("2" , is_single_player)
	
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

func restart():
	player_1.health = 100
	points_label.text = "Points: 0"
	points = 0
	if !is_single_player:
		player_2.health = 100
	update_health()
