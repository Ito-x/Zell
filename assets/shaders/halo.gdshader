shader_type canvas_item;

uniform float falloff : hint_range(0.5, 6.0) = 2.5;
uniform float inner_strength : hint_range(0.0, 3.0) = 1.0;

varying vec2 local_pos;
varying vec4 vert_color;

void vertex() {
	local_pos = VERTEX;
	vert_color = COLOR;
}

void fragment() {
	float r = clamp(length(local_pos) / 100.0, 0.0, 1.0);
	float falloff_a = pow(1.0 - r, falloff);
	float core = pow(1.0 - r, falloff * 3.0) * inner_strength;
	float a = (falloff_a + core) * vert_color.a;
	COLOR = vec4(vert_color.rgb, a);
}
