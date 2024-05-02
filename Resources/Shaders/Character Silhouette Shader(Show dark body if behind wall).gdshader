shader_type canvas_item;

// screen text to check if sprite is behind something
uniform sampler2D screen_texture: hint_screen_texture;

// silhouette color
uniform vec4 silhouette_color: source_color = vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
	// sample the screen color
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	// sample the sprite color
	vec4 sprite_color = texture(TEXTURE, UV);
	// Check if sprite & screen color match
	if(all(lessThan(abs(sprite_color - screen_color), vec4(0.01)))){
		// player is not behind obj
		COLOR = sprite_color;
	} else{
		// player is behind obj
		COLOR = vec4(silhouette_color.rgb , silhouette_color.a * sprite_color.a);
	}
}

