shader_type canvas_item;

uniform vec2 direction = vec2(1.0, 0.0);
uniform float speed_scale = 0.02;

void fragment() {
	vec2 move = direction * TIME * speed_scale;
	COLOR = texture(TEXTURE, UV + move);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
