extends Control

var peer = ENetMultiplayerPeer.new()
var connected_peer_ids = []
@export var player_scene:PackedScene

@onready var max_players_input = $VBoxContainer/Max_Players_Input
@onready var port_address = $VBoxContainer/Port_Address

func _on_host_pressed():
	var port_address = int(port_address.text)
	var max_clients = int(max_players_input.text)
	peer.create_server(port_address, max_clients) # 135 is an open port
	multiplayer.multiplayer_peer = peer
	$VBoxContainer.visible = false
	multiplayer.peer_connected.connect(add_player)
	add_player()
	
func add_player(id:int = 1):
	connected_peer_ids.append(id)
	var player:Multiplayer_Player = player_scene.instantiate()
	player.name = "Player" + str(id)
	call_deferred("add_child", player)
