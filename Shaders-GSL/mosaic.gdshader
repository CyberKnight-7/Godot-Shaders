shader_type canvas_item;

uniform float tiles: hint_range(4.0, 256.0, 0.1) = 80.0;
uniform float contrast: hint_range(1.0, 10.0, 0.01) = 2.0;
uniform float thickness: hint_range(0.0, 4.0, 0.01) = 0.5;
uniform float gamma: hint_range(1.0, 4.0, 0.01) = 2.2;

vec2 hash22(vec2 p){
	vec3 a = fract(p.xyx * vec3(123.34, 234.34, 345.65));
	a += dot(a, a + 34.45);
	return fract(vec2(a.x * a.y, a.y * a.z));
}

vec3 voronoi(vec2 p) {
	vec2 grid_coords = floor(p);
	vec2 grid_ud = fract(p);
	vec2 min_offset;
	vec2 min_vector;
	float min_dist = 100.0;
	for(float y = -1.0; y <= 1.0; y++){
		for(float x = -1.0; x <= 1.0; x++){
			vec2 offset = vec2(x, y);
			vec2 shift = hash22(grid_coords + offset);
			vec2 vector = offset + shift - grid_ud;
			float squared_dist = dot(vector, vector);
			if(squared_dist < min_dist) {
				min_dist = squared_dist;
				min_vector = vector;
				min_offset = offset;
			}
		}
	}
	//Gaps between tiles
	min_dist = 100.0;
	for(float y = -1.0; y <= 1.0; y++){
		for(float x = -1.0; x <= 1.0; x++){
			vec2 offset = vec2(x, y);
			vec2 shift = hash22(grid_coords + offset);
			vec2 vector = offset + shift - grid_ud;
			float squared_dist = dot(min_vector + vector, normalize(vector - min_vector));
			if(squared_dist < min_dist) {
				min_dist = squared_dist;
			}
		}
	}
	return vec3(grid_coords + min_offset, min_dist);
}

void fragment() {
	//Scaling
	vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	vec3 v = voronoi(uv * tiles) / tiles;
	vec2 vuv = v.xy;
	vuv.x *= resolution.y / resolution.x;
	vec3 color = texture(TEXTURE, vuv + 0.5).rgb;
	color = pow(color, vec3(contrast));
	color *= smoothstep(0.001, 0.001 + thickness * 0.01, v.z);
	color = pow(color, 1.0 / vec3(gamma));//gamma correction
	COLOR = vec4(color, 1.0);
	
}
