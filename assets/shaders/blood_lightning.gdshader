// Éclairs / veines sanguines pulsantes en couche additive sur le background.
// Couleur HDR rouge → bloom via WorldEnvironment glow.
shader_type canvas_item;
render_mode blend_add;

uniform vec4 bolt_color : source_color = vec4(1.6, 0.18, 0.12, 1.0);
uniform float scale = 0.0010;
uniform float bolt_width : hint_range(0.005, 0.10) = 0.022;
uniform float branch_strength : hint_range(0.0, 1.5) = 0.7;

// Densité = pourcentage de zones qui pulsent en même temps
uniform float density : hint_range(0.0, 1.0) = 0.18;
uniform float pulse_speed : hint_range(0.05, 3.0) = 0.65;
uniform float pulse_sharpness : hint_range(1.0, 12.0) = 7.0;

uniform float warp_speed = 0.04;
uniform float warp_amount = 0.25;

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
	vec2 uv = world_pos * scale;

	// Domain warp → casse les directions trop régulières
	vec2 warp = vec2(fbm(uv * 0.8 + TIME * warp_speed),
					 fbm(uv * 0.8 + 13.0 + TIME * warp_speed)) - 0.5;
	uv += warp * warp_amount;

	// Lignes de niveau du fbm autour de 0.5 → ribbons sinueuses
	float field = fbm(uv * 1.4);
	float ribbon_dist = abs(field - 0.5);
	float bolt = smoothstep(bolt_width, 0.0, ribbon_dist);

	// Branches secondaires (lignes de niveau d'un fbm plus fin)
	float field2 = fbm(uv * 3.2 + 23.0);
	float branch_dist = abs(field2 - 0.5);
	float branch = smoothstep(bolt_width * 0.55, 0.0, branch_dist) * branch_strength;

	// Pulsation par zone (grille assez large pour avoir 1-3 éclairs visibles)
	vec2 zone = floor(world_pos * 0.0011);
	float phase = hash(zone) * 6.2831;
	float speed_var = 0.5 + 0.8 * hash(zone + 7.3);
	float p = sin(TIME * pulse_speed * speed_var + phase) * 0.5 + 0.5;
	float pulse = pow(p, pulse_sharpness);

	// Sparse : la plupart des zones sont éteintes la plupart du temps
	float active = step(1.0 - density, hash(zone + 31.0));

	float intensity = (bolt + branch) * pulse * active;
	vec3 col = bolt_color.rgb * intensity;
	COLOR = vec4(col, intensity);
}
