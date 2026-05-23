shader_type canvas_item;

uniform vec3 base_color : source_color = vec3(0.35, 0.08, 0.10);
uniform vec3 deep_color : source_color = vec3(0.12, 0.02, 0.04);
uniform vec3 vein_color : source_color = vec3(0.55, 0.10, 0.12);
uniform float scale = 0.015;
uniform float pulse_speed = 0.6;
uniform float pulse_amount = 0.08;
uniform float wetness = 0.35;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 5; i++) {
		v += a * noise(p);
		p *= 2.03;
		a *= 0.5;
	}
	return v;
}

void fragment() {
	vec2 uv = world_pos * scale;
	float t = TIME * pulse_speed;

	float pulse = sin(t) * 0.5 + 0.5;
	uv += vec2(sin(t * 0.3), cos(t * 0.2)) * 0.05;

	float base_noise = fbm(uv);
	float detail = fbm(uv * 3.5 + base_noise);

	float veins = smoothstep(0.45, 0.55, detail);
	float dark_pockets = smoothstep(0.6, 0.3, base_noise);

	vec3 col = mix(deep_color, base_color, base_noise);
	col = mix(col, vein_color, veins * 0.45);
	col *= 1.0 - dark_pockets * 0.5;

	col *= 1.0 + pulse * pulse_amount;

	float wet = fbm(uv * 2.0 + vec2(t * 0.1, 0.0));
	col += vec3(0.4, 0.15, 0.15) * smoothstep(0.7, 0.85, wet) * wetness;

	COLOR = vec4(col, 1.0);
}
