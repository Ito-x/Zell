// Shader B — Sol & plafond : texture bourrelets/nodules très assombrie,
// avec auto-normal map depuis luminance pour interaction Light2D et relief.
// Les creux sont poussés au noir, les sommets gardent leur définition.
shader_type canvas_item;

uniform sampler2D source_tex : filter_linear_mipmap, repeat_enable;
uniform float tex_scale = 0.00085;

// Recoloration en deux pôles : shadow (creux/cavités) et highlight (sommets éclairés)
uniform vec3 shadow_color : source_color = vec3(0.005, 0.002, 0.0);
uniform vec3 highlight_color : source_color = vec3(0.42, 0.30, 0.22);

uniform float darkness : hint_range(0.0, 1.5) = 0.55;
uniform float contrast : hint_range(0.5, 5.0) = 2.4;

// Self-shadowing via normale calculée depuis la luminance
uniform float normal_strength : hint_range(0.0, 4.0) = 2.0;
uniform float auto_normal_kernel : hint_range(0.5, 6.0) = 2.0;
uniform float depth_contrast : hint_range(0.5, 4.0) = 2.2;
uniform float cavity_blackness : hint_range(0.0, 0.95) = 0.80;

// Squash & stretch lorsque le joueur impacte le sol
uniform vec2 impact_position = vec2(0.0, 0.0);
uniform float impact_intensity : hint_range(0.0, 30.0) = 0.0;
uniform float impact_radius : hint_range(20.0, 600.0) = 240.0;
uniform float impact_falloff : hint_range(1.0, 6.0) = 2.6;
uniform float vibration_speed : hint_range(2.0, 30.0) = 9.0;
uniform float wave_frequency : hint_range(0.005, 0.10) = 0.028;

// Pulse organique discret
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
	vec3 n = normal_from_luminance(uv, auto_normal_kernel);

	// Recoloration agressive : pow sur luminance pour pousser les sombres vers shadow_color
	float lum = luminance(src.rgb);
	float lum_c = pow(lum, contrast);
	vec3 col = mix(shadow_color, highlight_color, lum_c);

	// Self-shadow par normale Z : creux deviennent quasi-noirs
	float cavity = pow(clamp(n.z, 0.0, 1.0), depth_contrast);
	col *= mix(1.0 - cavity_blackness, 1.0, cavity);

	col *= darkness;

	if (breath_speed > 0.001) {
		float p = 0.5 + 0.5 * sin(TIME * breath_speed);
		float pulse = p * p * (3.0 - 2.0 * p);
		col *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;
	}

	COLOR = vec4(col, 1.0);
	NORMAL = n;
}
