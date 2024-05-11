extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	DiscordRPC.app_id = 1224374449084567755
	DiscordRPC.state = "Playing"
	DiscordRPC.details = "ABD RMN"
	DiscordRPC.refresh()
