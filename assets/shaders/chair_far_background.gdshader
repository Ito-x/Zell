// Shader A — Far background : texture chair rouge poussée vers le noir
// + éclairs/veines sanguines pulsantes intégrées (additif).
shader_type canvas_item;

uniform sampler2D source_tex : filter_linear_mipmap, repeat_enable;
uniform float tex_scale = 0.0007;

uniform vec3 tint : source_color = vec3(0.42, 0.10, 0.10);
uniform float darkness : hint_range(0.0, 1.5) = 0.55;
uniform float contrast : hint_range(0.5, 5.0) = 1.6;

uniform float breath_speed : hint_range(0.0, 2.0) = 0.14;
uniform float breath_amount : hint_range(0.0, 0.3) = 0.06;

uniform float distortion_strength : hint_range(0.0, 0.02) = 0.004;
uniform float distortion_speed = 0.04;

// --- Éclairs sanguins intégrés ---
uniform vec3 blood_color : source_color = vec3(2.4, 0.30, 0.20);
uniform float blood_scale = 0.0010;
uniform float blood_bolt_width : hint_range(0.005, 0.10) = 0.022;
uniform float blood_branch_strength : hint_range(0.0, 1.5) = 0.7;
uniform float blood_density : hint_range(0.0, 1.0) = 0.22;
uniform float blood_pulse_speed : hint_range(0.05, 3.0) = 0.65;
uniform float blood_pulse_sharpness : hint_range(1.0, 12.0) = 7.0;
uniform float blood_warp_amount = 0.25;
uniform float blood_warp_speed = 0.04;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 hash22(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	float a = dot(hash22(i),                f);
	float b = dot(hash22(i + vec2(1, 0)),   f - vec2(1, 0));
	float c = dot(hash22(i + vec2(0, 1)),   f - vec2(0, 1));
	float d = dot(hash22(i + vec2(1, 1)),   f - vec2(1, 1));
	return 0.5 + 0.5 * mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		v += a * gnoise(p);
		p = p * 2.05 + 11.3;
		a *= 0.55;
	}
	return v;
}

void fragment() {
	// --- Background chair ---
	float t = TIME * distortion_speed;
	vec2 warp = vec2(gnoise(world_pos * tex_scale * 4.0 + vec2(t, 0.0)),
					 gnoise(world_pos * tex_scale * 4.0 + vec2(0.0, t + 11.0)));

	vec2 uv = world_pos * tex_scale + (warp - 0.5) * distortion_strength;

	vec4 src = texture(source_tex, uv);
	float lum = dot(src.rgb, vec3(0.299, 0.587, 0.114));
	float lum_c = pow(lum, contrast);

	vec3 col = tint * lum_c;
	col *= darkness;

	float p_breath = 0.5 + 0.5 * sin(TIME * breath_speed);
	float pulse = p_breath * p_breath * (3.0 - 2.0 * p_breath);
	col *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;

	// --- Éclairs sanguins (additifs sur le background) ---
	vec2 luv = world_pos * blood_scale;
	vec2 lwarp = vec2(fbm(luv * 0.8 + TIME * blood_warp_speed),
					  fbm(luv * 0.8 + 13.0 + TIME * blood_warp_speed)) - 0.5;
	luv += lwarp * blood_warp_amount;

	float field = fbm(luv * 1.4);
	float ribbon_dist = abs(field - 0.5);
	float bolt = smoothstep(blood_bolt_width, 0.0, ribbon_dist);

	float field2 = fbm(luv * 3.2 + 23.0);
	float branch_dist = abs(field2 - 0.5);
	float branch = smoothstep(blood_bolt_width * 0.55, 0.0, branch_dist) * blood_branch_strength;

	vec2 zone = floor(world_pos * 0.003);
	float bphase = hash(zone) * 6.2831;
	float bspeed = 0.5 + 0.8 * hash(zone + 7.3);
	float bp = sin(TIME * blood_pulse_speed * bspeed + bphase) * 0.5 + 0.5;
	float bpulse = pow(bp, blood_pulse_sharpness);
	float bactive = step(1.0 - blood_density, hash(zone + 31.0));

	// Base d'intensité constante + pulse → éclairs toujours un peu visibles
	float base = 0.25;
	float bolt_intensity = (bolt + branch) * (base + (1.0 - base) * bpulse) * bactive;
	col += blood_color * bolt_intensity;

	COLOR = vec4(col, 1.0);
}
