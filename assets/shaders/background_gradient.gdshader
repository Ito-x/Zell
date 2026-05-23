shader_type canvas_item;

uniform vec4 color_top : source_color = vec4(0.10, 0.04, 0.18, 1.0);
uniform vec4 color_middle : source_color = vec4(0.04, 0.02, 0.10, 1.0);
uniform vec4 color_bottom : source_color = vec4(0.005, 0.003, 0.02, 1.0);
uniform float gradient_top_y = -800.0;
uniform float gradient_bottom_y = 800.0;
uniform float nebula_strength : hint_range(0.0, 0.5) = 0.18;
uniform vec3 nebula_color : source_color = vec3(0.20, 0.08, 0.35);
uniform float nebula_scale = 0.0008;
uniform float dither_strength = 0.012;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 hash22(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

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
	for (int i = 0; i < 5; i++) {
		v += a * gnoise(p);
		p = p * 2.05 + 11.3;
		a *= 0.5;
	}
	return v;
}

void fragment() {
	float t = clamp((world_pos.y - gradient_top_y) / (gradient_bottom_y - gradient_top_y), 0.0, 1.0);
	// Lissage cubique pour éviter les transitions abruptes
	float ts = t * t * (3.0 - 2.0 * t);

	vec4 col;
	if (ts < 0.5) {
		float k = ts * 2.0;
		k = k * k * (3.0 - 2.0 * k);
		col = mix(color_top, color_middle, k);
	} else {
		float k = (ts - 0.5) * 2.0;
		k = k * k * (3.0 - 2.0 * k);
		col = mix(color_middle, color_bottom, k);
	}

	vec2 nuv = world_pos * nebula_scale;
	float n1 = fbm(nuv);
	float n2 = fbm(nuv * 2.3 + vec2(11.7, 5.3));
	float nebula = max(0.0, n1 - n2 * 0.5);
	col.rgb += nebula_color * nebula * nebula_strength;

	// Dither anti-banding (bruit faible quantifié au 1/255)
	float dither = fract(sin(dot(world_pos, vec2(12.9898, 78.233))) * 43758.5453) - 0.5;
	col.rgb += dither * dither_strength;

	// Alpha basé sur la luminosité : les zones noires deviennent transparentes
	// pour laisser passer la couche de chair rouge derrière.
	float vis = max(col.r, max(col.g, col.b));
	float alpha = smoothstep(0.005, 0.10, vis);

	COLOR = vec4(col.rgb, alpha);
}
