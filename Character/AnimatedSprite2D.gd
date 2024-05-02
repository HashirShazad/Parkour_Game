extends AnimatedSprite2D

@onready var silhouette_sprite = $Silhouette_Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	#silhouette_sprite.texture = texture
	silhouette_sprite.offset = offset
	silhouette_sprite.flip_h = flip_h
	silhouette_sprite.frame = frame
	silhouette_sprite.animation = animation
	silhouette_sprite.play(animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _set(property: StringName, value: Variant) -> bool:
	if is_instance_valid(silhouette_sprite):
		match property:
			"animation":
				silhouette_sprite.animation = value
				silhouette_sprite.play()
			#"texture":
				#silhouette_sprite.texture = value
			"offset":
				silhouette_sprite.offset = value
			"flip_h":
				silhouette_sprite.flip_h = value
			"frame":
				silhouette_sprite.frame = value
			
	return false
				
