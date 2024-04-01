extends Node

@onready var points_label = $Hud/Node/Coin_Info_Box/PointsLabel
@onready var pause_menu = $Pause_Menu
@onready var death_screen = $Death_Screen

var player_1
var player_2
@onready var hp_bar_P1 = $Hud/Node/Player_Info_Box/Panel/ProgressBar
@onready var hp_bar_P2 = $Hud/Node/Player2_Info_Box/Panel/ProgressBar

var points = 0
var paused:bool = false
var death_screen_shown:bool = false

	
func _process(delta):
	if player_1 && player_2:
		if Input.is_action_just_pressed("Pause") && !death_screen_shown:
			pause()
		if Input.is_action_just_pressed("Restart") && paused:
			_on_restart_button_pressed()
		if Input.is_action_just_pressed("Restart") && death_screen_shown:
			_on_retry_button_pressed()
		if player_1.is_dead:
			player_1.position = player_2.position
		if player_2.is_dead:
			player_2.position = player_1.position
		if player_1.is_dead && player_2.is_dead:
			death_screen.show()
			death_screen_shown = true
			
func pause():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func add_points(collected_points:int) -> void:	
	points = points + collected_points
	points_label.text = "Points: " + str(points)

func _on_play_button_pressed():
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")

func _on_close_button_pressed():
	
	get_tree().quit()

func _on_resume_button_pressed():
	pause()

func _on_back_button_pressed():
	pause()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")

func _on_restart_button_pressed():
	# Pause menu button
	points_label.text = "Points: 0"
	points = 0
	pause()
	player_1.health = 100
	player_2.health = 100
	death_screen_shown = false
	update_health()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)

func update_health():
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar_P1, "value", player_1.health, .1).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(hp_bar_P2, "value", player_2.health, .1).set_trans(Tween.TRANS_QUAD)
	
func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://UI/Settings_Menu.tscn")

func _on_retry_button_pressed():
	#Death_Screen button
	points_label.text = "Points: 0"
	points = 0
	player_1.health = 100
	player_2.health = 100
	death_screen_shown = false
	paused = false
	death_screen.hide()
	update_health()
	Transitioner.start_transition()
	await Transitioner.transiton_finsihed
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	

