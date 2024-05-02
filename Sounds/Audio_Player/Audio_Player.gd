extends AudioStreamPlayer

# Bg Music Player <----------------------------------------------------------------------------->
func play_music(music:AudioStream, volume = 0.0):
	# If the music is already being played then return and do nothing
	if stream == music:
		return
	# Otherwise assign the new music to be played
	stream = music
	volume_db = volume
	play()
	
# Sound effect player <------------------------------------------------------------->
func play_FX(stream: AudioStream, volume = 0.0, lower_bound: int = 0.8, upper_bound: int = 1.3):
	# Create new stream player
	# Was normal not 2D before 
	var fx_player = AudioStreamPlayer2D.new()
	# Assign its variables
	fx_player.bus = &"SFX"
	fx_player.stream = stream
	fx_player.name = "fx_player"
	fx_player.volume_db = volume
	# Add random pitch
	fx_player.pitch_scale = randf_range(lower_bound, upper_bound)
	add_child(fx_player)
	fx_player.play()
	# Destroy when completed
	await fx_player.finished
	fx_player.queue_free()
