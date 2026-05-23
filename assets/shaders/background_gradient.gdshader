shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.10, 0.04, 0.18, 1.0);
uniform vec4 color_middle : source_color = vec4(0.04, 0.02, 0.10, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.005, 0.003, 0.02, 1.0);
uniform float gradient_top_y = -800.0;
uniform float gradient_bottom_y = 800.0;
uniform float nebula_strength : hint_range(0.0, 0.5) = 0.18;
uniform vec3 nebula_color : source_color = vec3(0.20, 0.08, 0.35);
uniform float nebula_scale = 0.0008;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1, 0)), f.x),
			   mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 5; i++) {
		v += a * noise(p);
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

void fragment() {
	float t = clamp((world_pos.y - gradient_top_y) / (gradient_bottom_y - gradient_top_y), 0.0, 1.0);

	vec4 col;
	if (t < 0.5) {
		col = mix(color_top, color_middle, t * 2.0);
	} else {
		col = mix(color_middle, color_bottom, (t - 0.5) * 2.0);
	}

	vec2 nuv = world_pos * nebula_scale;
	float n1 = fbm(nuv);
	float n2 = fbm(nuv * 2.3 + vec2(11.7, 5.3));
	float nebula = max(0.0, n1 - n2 * 0.5);
	col.rgb += nebula_color * nebula * nebula_strength;

	COLOR = col;
}
