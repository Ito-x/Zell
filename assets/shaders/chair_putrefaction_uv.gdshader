// Variante de chair_putrefaction qui mappe la texture sur les UV du polygon
// (au lieu de world_pos × scale). Permet d'utiliser des polygons trapèzes
// avec UVs custom pour créer un effet de perspective tunnel.
shader_type canvas_item;

uniform sampler2D source_tex : filter_linear_mipmap, repeat_enable;
uniform vec2 tex_repeat = vec2(4.0, 6.0);

uniform vec3 tint : source_color = vec3(0.85, 0.70, 0.55);
uniform float darkness : hint_range(0.0, 1.5) = 0.55;
uniform float contrast : hint_range(0.5, 4.0) = 1.5;
uniform float gamma : hint_range(0.5, 3.0) = 1.2;

uniform float normal_strength : hint_range(0.0, 4.0) = 1.8;
uniform float auto_normal_kernel : hint_range(0.5, 6.0) = 1.5;
uniform float depth_contrast : hint_range(0.5, 4.0) = 1.6;
uniform float cavity_blackness : hint_range(0.0, 0.95) = 0.45;

// Renforcement de la perspective : assombrit les pixels "lointains" (UV.y faible)
uniform float distance_fade : hint_range(0.0, 1.0) = 0.55;
uniform float fade_curve : hint_range(0.5, 4.0) = 1.6;

uniform float breath_speed : hint_range(0.0, 2.0) = 0.18;
uniform float breath_amount : hint_range(0.0, 0.2) = 0.04;

float luminance(vec3 c) {
	return dot(c, vec3(0.299, 0.587, 0.114));
}

vec3 normal_from_luminance(vec2 uv, float k) {
	vec2 px = vec2(k) / 512.0;
	float h_l = luminance(texture(source_tex, uv - vec2(px.x, 0.0)).rgb);
	float h_r = luminance(texture(source_tex, uv + vec2(px.x, 0.0)).rgb);
	float h_d = luminance(texture(source_tex, uv - vec2(0.0, px.y)).rgb);
	float h_u = luminance(texture(source_tex, uv + vec2(0.0, px.y)).rgb);
	vec3 n = vec3((h_r - h_l) * normal_strength * 3.0,
				  (h_d - h_u) * normal_strength * 3.0,
				  1.0);
	return normalize(n);
}

void fragment() {
	// UV.y attendu : 0 au loin (horizon), 1 devant (proche du joueur)
	float depth = UV.y;
	vec2 uv = UV * tex_repeat;

	vec4 src = texture(source_tex, uv);
	vec3 col = src.rgb;

	col = (col - 0.5) * contrast + 0.5;
	col = clamp(col, 0.0, 1.0);
	col *= tint;

	vec3 n = normal_from_luminance(uv, auto_normal_kernel);
	float cavity = pow(clamp(n.z, 0.0, 1.0), depth_contrast);
	col *= mix(1.0 - cavity_blackness, 1.0, cavity);

	col = pow(col, vec3(gamma));
	col *= darkness;

	// Fade vers le noir au fur et à mesure qu'on s'éloigne (UV.y → 0)
	float far_factor = pow(depth, fade_curve);
	col *= mix(1.0 - distance_fade, 1.0, far_factor);

	if (breath_speed > 0.001) {
		float p = 0.5 + 0.5 * sin(TIME * breath_speed);
		float pulse = p * p * (3.0 - 2.0 * p);
		col *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;
	}

	COLOR = vec4(col, 1.0);
	NORMAL = n;
}
