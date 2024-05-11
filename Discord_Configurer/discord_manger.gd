extends Node

var is_single_player:bool = false

var discord_images:Dictionary = {
	background = "background",
	cannibal = "cannibal",
	hashir_icon = "hashir_icon",
	kaizo_poyo_logo = "kaizo_poyo_logo"
}
# Called when the node enters the scene tree for the first time.
func _ready():
	DiscordRPC.app_id = 1224374449084567755
	DiscordRPC.state = "Playing"
	DiscordRPC.details = "ABD RMN"
	update_presence()
	DiscordRPC.refresh()

func _process(delta):
	DiscordRPC.run_callbacks()
## Got to this link https://discord.com/developers/applications/1224374449084567755/rich-presence/visualizer
func update_presence():
	DiscordRPC.max_party_size = 2
	DiscordRPC.join_secret = "MTI4NzM0OjFpMmhuZToxMjMxMjM= "
	DiscordRPC.party_id = "ae488379-351d-4a4f-ad32-2b9b01c91657"
	DiscordRPC.large_image = "hashir_icon"
	DiscordRPC.large_image_text = "Playing a game made by hashir"
	# It is really imp to go to the link for stuff also https://vaporvee.com/docs/discord-rpc-godot
	#DiscordRichPresence = DiscordRPC;
	#memset(&DiscordRPC, 0, sizeof(DiscordRPC));
	if is_single_player:
		DiscordRPC.state = "Playing Solo"
		DiscordRPC.small_image = "pono"
		DiscordRPC.small_image_text = "Playing as Pono"
		DiscordRPC.current_party_size = 1
	else:
		DiscordRPC.state = "Playing Coop"
		DiscordRPC.small_image = "pono_and_mina"
		DiscordRPC.small_image_text = "Playing as Pono & Mina"
		DiscordRPC.current_party_size = 2
	DiscordRPC.details = "Casual"
	#DiscordRPC.start_timestamp = 1507665886;
	#DiscordRPC.end_timestamp = 1507665886;


	

	
	
	#Discord_UpdatePresence(&DiscordRPC);
