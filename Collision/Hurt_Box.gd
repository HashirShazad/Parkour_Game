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
	#for to_ignore in hitbox.to_ignore:
		#print(owner)
		#if owner == to_ignore:
			#return
	if hitbox.has_method("destroy"):
		hitbox.destroy()
	#if "kb_direction" in hitbox:
		#if owner.has_method("take_fixed_direction_knockback"):
			#owner.take_fixed_direction_knockback(hitbox.knock_back_strength, hitbox.kb_direction)
	if owner.has_method("take_knockback"):
		var angle = hitbox.global_position.direction_to(global_position)
		angle = vec_to_dir(angle)
		owner.take_knockback(hitbox.knock_back_strength, angle)
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, hitbox.stun_duration)

func vec_to_dir(vec : Vector2)->Vector2:
	if vec == Vector2.ZERO:
		return Vector2.ZERO
	var ass = abs(vec.aspect())
	var res = vec.sign()
	if ass < 0.557852 or ass > 1.79259:
		res[int(ass > 1.0)] = 0
	return res
	

