extends Enemy

const  BULLET = preload("res://Enemies/Plant/Bullet.tscn")

func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Players"):
		var bullet = BULLET.instantiate()
		get_parent().add_child(bullet)
		bullet.flip_h = true
