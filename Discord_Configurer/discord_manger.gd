extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	DiscordRPC.app_id = 1224374449084567755
	DiscordRPC.state = "Playing"
	DiscordRPC.details = "ABD RMN"
	update_presence()
	DiscordRPC.refresh()
	
## Got to this link https://discord.com/developers/applications/1224374449084567755/rich-presence/visualizer
func update_presence():
	# It is really imn
	#DiscordRichPresence = DiscordRPC;
	#memset(&DiscordRPC, 0, sizeof(DiscordRPC));
	DiscordRPC.state = "Playing Solo"
	DiscordRPC.details = "Casual"
	#DiscordRPC.start_timestamp = 1507665886;
	#DiscordRPC.end_timestamp = 1507665886;
	DiscordRPC.large_image = "hashir_icon"
	DiscordRPC.large_image_text = "Playing a game made by hashir"
	DiscordRPC.small_image = "pono"
	DiscordRPC.small_image_text = "Playing as Pono"
	DiscordRPC.party_id = "ae488379-351d-4a4f-ad32-2b9b01c91657"
	DiscordRPC.current_party_size = 1
	DiscordRPC.max_party_size = 2
	DiscordRPC.join_secret = "MTI4NzM0OjFpMmhuZToxMjMxMjM= "
	#Discord_UpdatePresence(&DiscordRPC);
