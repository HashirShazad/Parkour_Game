extends AudioStreamPlayer2D

const LEVEL_MUSIC = preload("res://Sounds/BG_Music/Crumbling Dreams (Ballora's Theme).wav")


func play_music(music:AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_FX(stream: AudioStream, volume = 0.0, lower_bound: int = 0.8, upper_bound: int = 1.3):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "fx_player"
	fx_player.volume_db = volume
	fx_player.pitch_scale = randf_range(lower_bound, upper_bound)
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()
