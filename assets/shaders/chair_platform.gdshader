// Sol / plateforme chair-tapis avec bourrelets (variante avec sampler explicite).
// Pour la version utilisée par les trapèzes perspective, voir chair_putrefaction_uv.gdshader.
shader_type canvas_item;

uniform sampler2D albedo_tex : filter_linear_mipmap, repeat_enable;
uniform sampler2D normal_tex : hint_normal, filter_linear_mipmap, repeat_enable;

uniform float normal_strength : hint_range(0.0, 4.0) = 1.4;
uniform float depth_contrast : hint_range(0.3, 4.0) = 1.6;
uniform float cavity_darkness : hint_range(0.0, 0.95) = 0.55;
uniform float roughness : hint_range(0.0, 1.5) = 0.4;
uniform vec4 tint : source_color = vec4(1.0, 0.92, 0.85, 1.0);
uniform float overall_brightness : hint_range(0.0, 2.0) = 1.0;

uniform bool use_auto_normal = true;
uniform float auto_normal_kernel : hint_range(1.0, 6.0) = 2.0;

uniform vec2 impact_position = vec2(0.0, 0.0);
uniform float impact_intensity : hint_range(0.0, 30.0) = 0.0;
uniform float impact_radius : hint_range(20.0, 600.0) = 220.0;
uniform float impact_falloff : hint_range(1.0, 6.0) = 2.6;
uniform float vibration_speed : hint_range(2.0, 30.0) = 9.0;
uniform float wave_frequency : hint_range(0.005, 0.10) = 0.028;

uniform float breath_speed : hint_range(0.0, 2.0) = 0.0;
uniform float breath_amount : hint_range(0.0, 0.3) = 0.06;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 squash_uv_offset() {
	vec2 d = world_pos - impact_position;
	float dist = length(d);
	float radial = max(0.0, 1.0 - dist / impact_radius);
	float falloff = pow(radial, impact_falloff);
	float wave = sin(TIME * vibration_speed - dist * wave_frequency) * falloff;
	vec2 dir = dist > 0.001 ? d / dist : vec2(0.0, -1.0);
	return -dir * wave * impact_intensity;
}

float luminance(vec3 c) {
	return dot(c, vec3(0.299, 0.587, 0.114));
}

vec3 normal_from_luminance(vec2 uv) {
	vec2 px = (1.0 / vec2(textureSize(albedo_tex, 0))) * auto_normal_kernel;
	float h_l = luminance(texture(albedo_tex, uv - vec2(px.x, 0.0)).rgb);
	float h_r = luminance(texture(albedo_tex, uv + vec2(px.x, 0.0)).rgb);
	float h_d = luminance(texture(albedo_tex, uv - vec2(0.0, px.y)).rgb);
	float h_u = luminance(texture(albedo_tex, uv + vec2(0.0, px.y)).rgb);
	vec3 n = vec3((h_r - h_l) * normal_strength * 3.0,
				  (h_d - h_u) * normal_strength * 3.0,
				  1.0);
	return normalize(n);
}

void fragment() {
	vec2 offset_world = squash_uv_offset();
	vec2 uv = UV + offset_world * (1.0 / vec2(textureSize(albedo_tex, 0)));

	vec4 albedo = texture(albedo_tex, uv) * tint;
	albedo.rgb *= overall_brightness;

	vec3 n;
	if (use_auto_normal) {
		n = normal_from_luminance(uv);
	} else {
		vec3 n_sample = texture(normal_tex, uv).rgb;
		n = n_sample * 2.0 - 1.0;
		n.xy *= normal_strength;
		n = normalize(n);
	}

	float cavity = pow(clamp(n.z, 0.0, 1.0), depth_contrast);
	albedo.rgb *= mix(cavity_darkness, 1.0, cavity);

	float lum = luminance(texture(albedo_tex, uv).rgb);
	albedo.rgb *= 1.0 + (lum - 0.5) * roughness * 0.5;

	if (breath_speed > 0.001) {
		float p = 0.5 + 0.5 * sin(TIME * breath_speed);
		float pulse = p * p * (3.0 - 2.0 * p);
		albedo.rgb *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;
	}

	COLOR = albedo;
	NORMAL = n;
}
