extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene:PackedScene

@onready var bg:CanvasLayer = $CanvasLayer/BG


func _on_host_pressed():
	peer.create_server(135) # 135 is an open port
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	bg.visible = false
	
func _on_join_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	bg.visible = false
	
	
func add_player(id:int = 1):
	var player:Player = player_scene.instantiate()
	player.name = "Player" + str(id)
	call_deferred("add_child", player)
