extends Node
class_name Discord_Manager

var is_single_player:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	DiscordRPC.app_id = 1224374449084567755
	DiscordRPC.state = "Playing"
	DiscordRPC.details = "ABD RMN"
	#DiscordRPC.get_current_user()
	#print(DiscordRPC.get_current_user())
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
		DiscordRPC.small_image_text = "Playing as Pono"
	else:
		DiscordRPC.state = "Playing Coop"
		DiscordRPC.small_image_text = "Playing as Pono & Mina"
	DiscordRPC.details = "Casual"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system());
	#DiscordRPC.end_timestamp = 1507665886;
	DiscordRPC.small_image = "pono"
	DiscordRPC.current_party_size = 1
	
	#Discord_UpdatePresence(&DiscordRPC);
