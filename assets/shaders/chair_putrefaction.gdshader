// Shader B — Sol & plafond : assombrit l'image source SANS la recolorer entièrement.
// La structure et les highlights des bourrelets restent reconnaissables.
shader_type canvas_item;

uniform sampler2D source_tex : filter_linear_mipmap, repeat_enable;
uniform float tex_scale = 0.0018;

// Tint multiplicateur sur la couleur originale (garde la teinte de la texture)
uniform vec3 tint : source_color = vec3(0.85, 0.70, 0.55);
uniform float darkness : hint_range(0.0, 1.5) = 0.55;

// Boost contrast around mid-gray pour faire ressortir les bumps
uniform float contrast : hint_range(0.5, 4.0) = 1.5;
// Push final : courbe gamma pour pousser légèrement vers le noir tout en gardant highlights
uniform float gamma : hint_range(0.5, 3.0) = 1.2;

// Auto-normal depuis la luminance pour Light2D + self-shadow
uniform float normal_strength : hint_range(0.0, 4.0) = 1.8;
uniform float auto_normal_kernel : hint_range(0.5, 6.0) = 1.5;
uniform float depth_contrast : hint_range(0.5, 4.0) = 1.6;
uniform float cavity_blackness : hint_range(0.0, 0.95) = 0.45;

// Impact (squash & stretch)
uniform vec2 impact_position = vec2(0.0, 0.0);
uniform float impact_intensity : hint_range(0.0, 30.0) = 0.0;
uniform float impact_radius : hint_range(20.0, 600.0) = 240.0;
uniform float impact_falloff : hint_range(1.0, 6.0) = 2.6;
uniform float vibration_speed : hint_range(2.0, 30.0) = 9.0;
uniform float wave_frequency : hint_range(0.005, 0.10) = 0.028;

// Pulse organique très discret
uniform float breath_speed : hint_range(0.0, 2.0) = 0.18;
uniform float breath_amount : hint_range(0.0, 0.2) = 0.04;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

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

vec2 squash_offset() {
	vec2 d = world_pos - impact_position;
	float dist = length(d);
	float radial = max(0.0, 1.0 - dist / impact_radius);
	float falloff = pow(radial, impact_falloff);
	float wave = sin(TIME * vibration_speed - dist * wave_frequency) * falloff;
	vec2 dir = dist > 0.001 ? d / dist : vec2(0.0, -1.0);
	return -dir * wave * impact_intensity;
}

void fragment() {
	vec2 offset = squash_offset();
	vec2 uv = world_pos * tex_scale + offset * tex_scale;

	vec4 src = texture(source_tex, uv);
	vec3 col = src.rgb;

	// Contraste autour de 0.5 (étire la dynamique → bumps mieux marqués)
	col = (col - 0.5) * contrast + 0.5;
	col = clamp(col, 0.0, 1.0);

	// Tint multiplicatif : conserve les variations de couleur de l'image
	col *= tint;

	// Self-shadow par normale Z : creux entre bourrelets enfoncés
	vec3 n = normal_from_luminance(uv, auto_normal_kernel);
	float cavity = pow(clamp(n.z, 0.0, 1.0), depth_contrast);
	col *= mix(1.0 - cavity_blackness, 1.0, cavity);

	// Gamma final → pousse les sombres vers le noir, garde les highlights
	col = pow(col, vec3(gamma));

	col *= darkness;

	// Pulse discret
	if (breath_speed > 0.001) {
		float p = 0.5 + 0.5 * sin(TIME * breath_speed);
		float pulse = p * p * (3.0 - 2.0 * p);
		col *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;
	}

	COLOR = vec4(col, 1.0);
	NORMAL = n;
}
