extends Node2D

var peer = ENetMultiplayerPeer.new()
var connected_peer_ids = []
#var player_numbers = 1

@export var player_scene:PackedScene

@onready var bg:CanvasLayer = $CanvasLayer
@onready var port_address_line = $"CanvasLayer/BG/IP address"

#func _ready():
	#var upnp:UPNP = UPNP.new()
	#var discover_result = upnp.discover()
	#if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		#if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			## 0 is the time might not work with all routers
			#var map_result_udp = upnp.add_port_mapping(9999,9999,"godot_udp","UDP", 0)
			#var map_result_tcp = upnp.add_port_mapping(9999,9999,"godot_udp","TCP", 0)
			#if !map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				## try both with and without the string description
				#upnp.add_port_mapping(9999,9999,"","UDP", 0)
			#if !map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				## try both with and without the string description
				#upnp.add_port_mapping(9999,9999,"","TCP", 0)
				#
	#var external_ip = upnp.query_external_address()
	#
	#
	#upnp.delete_port_mapping(9999, "UDP")
	#upnp.delete_port_mapping(9999, "TCP")

func _on_host_pressed():
	var port_address = int(port_address_line.text)
	peer.create_server(port_address) # 135 is an open port
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	bg.visible = false
	
func _on_join_pressed():
	var port_address = int(port_address_line.text)
	peer.create_client("localhost", port_address) # local host is equal to 127.0.0.1
	multiplayer.multiplayer_peer = peer
	bg.visible = false
	
	
func add_player(id:int = 1):
	connected_peer_ids.append(id)
	var player:Multiplayer_Player = player_scene.instantiate()
	player.name = "Player" + str(id)
	call_deferred("add_child", player)
