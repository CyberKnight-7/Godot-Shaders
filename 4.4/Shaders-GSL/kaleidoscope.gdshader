shader_type canvas_item;

uniform vec2 resolution = vec2(1920.0, 1080.0);
uniform sampler2D tex: repeat_enable, hint_default_black;
uniform float slices: hint_range(2.0, 100.0, 1.0) = 12.0;
uniform float speed: hint_range(0.0, 10.0, 0.01) = 0.5;

mat2 rotate(float a) {
	float sa = sin(a);
	float ca = cos(a);
	return mat2(vec2(ca, sa), vec2(-sa, ca));
}

vec2 fold(vec2 uv){
	float theta = atan(uv.x, uv.y);
	float slice = TAU / slices;
	float id = floor(theta / slice);
	float angle = slice * id;
	if(mod(id, 2.0) >= 1.0) {
		uv.y = -uv.y;
		angle = -(slice * (id + slices / 2.0 + 1.0));
	}
	uv = rotate(angle) * uv;
	return uv;
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	float angle = TIME * speed;
	uv = rotate(angle) * fold(uv);
	COLOR = texture(tex, uv);
}