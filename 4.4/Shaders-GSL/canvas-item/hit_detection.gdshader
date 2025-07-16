shader_type canvas_item;

uniform int count = 5;
uniform vec4 color: source_color = vec4(1.0);
uniform float interval = 0.1;

void fragment() {
	float t = mod(TIME, interval * float(count));
	int step = int(t / interval);
	
	if(mod(float(step), 2.0) < 1.0) {
		COLOR = color;
	} else {
		COLOR = texture(TEXTURE, UV);
	}
	
}