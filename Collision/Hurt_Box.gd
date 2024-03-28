extends Area2D
class_name Hurt_Box

func _init() -> void:
	collision_layer = 2
	collision_mask = 2

	
func area_entered(area):
	_on_area_entered(area)
	
func _on_area_entered(hitbox: Hit_Box) -> void:
	if hitbox == null:
		return
	if owner.has_method("take_knockback"):
		owner.take_knockback(hitbox.knock_back_direction, hitbox.knock_back_strength)
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, hitbox.stun_duration)