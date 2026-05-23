shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(0.85, 0.88, 1.0, 0.22);
uniform float density : hint_range(0.0, 2.0) = 1.0;
uniform float scroll_speed = 0.015;
uniform float noise_scale = 0.0012;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 hash22(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

// Gradient noise (Perlin-like), avec interpolation quintique → bien plus lisse que value noise
float gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	float a = dot(hash22(i), f);
	float b = dot(hash22(i + vec2(1, 0)), f - vec2(1, 0));
	float c = dot(hash22(i + vec2(0, 1)), f - vec2(0, 1));
	float d = dot(hash22(i + vec2(1, 1)), f - vec2(1, 1));
	return 0.5 + 0.5 * mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 6; i++) {
		v += a * gnoise(p);
		p = p * 2.07 + 13.7;
		a *= 0.55;
	}
	return v;
}

void fragment() {
	vec2 uv = world_pos * noise_scale;
	uv += vec2(TIME * scroll_speed, TIME * scroll_speed * 0.45);

	// Domain warp → aspect nuage moelleux
	vec2 warp = vec2(fbm(uv * 1.3), fbm(uv * 1.3 + 7.5));
	float n = fbm(uv * 1.4 + warp * 0.7);

	float band = smoothstep(0.30, 0.85, n);
	float a = fog_color.a * band * density;
	COLOR = vec4(fog_color.rgb, a);
}
