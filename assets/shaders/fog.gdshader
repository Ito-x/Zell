shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(0.85, 0.88, 1.0, 0.22);
uniform float density : hint_range(0.0, 2.0) = 1.0;
uniform float scroll_speed = 0.015;
uniform float noise_scale = 0.0012;

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
	for (int i = 0; i < 4; i++) {
		v += a * noise(p);
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

void fragment() {
	vec2 uv = world_pos * noise_scale;
	uv += vec2(TIME * scroll_speed, TIME * scroll_speed * 0.4);
	float n = fbm(uv * 1.5);
	float n2 = fbm(uv * 3.0 + 13.0);
	float band = smoothstep(0.35, 0.75, n) * (0.6 + 0.4 * n2);
	float a = fog_color.a * band * density;
	COLOR = vec4(fog_color.rgb, a);
}
