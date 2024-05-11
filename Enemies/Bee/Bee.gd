extends Enemy
class_name  Flying_Enemy

var diretion : Vector2

var is_bat_chasing : bool


	
func move(delta):
	if !is_bat_chasing:
		velocity += diretion * speed * diretion


func _on_timer_timeout():
	$Timer.wait_time = choose_random([1,0,1.6,2.0])
	if !is_bat_chasing:
		diretion = choose_random([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		print(diretion)
func choose_random(array:Array):
	array.shuffle()
	return array.front()
