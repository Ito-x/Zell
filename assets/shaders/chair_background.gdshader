// Fond de zone chair organique — respire, ondule, se teinte.
// À appliquer sur un TextureRect, Sprite2D ou Polygon2D dans un ParallaxLayer.
shader_type canvas_item;

uniform vec4 tint : source_color = vec4(1.0, 0.85, 0.82, 1.0);
uniform float darkness : hint_range(0.1, 1.0) = 0.55;

// Respiration : variation lente de luminosité + teinte légèrement plus saturée à l'expiration.
uniform float breath_speed : hint_range(0.05, 2.0) = 0.4;
uniform float breath_amount : hint_range(0.0, 0.4) = 0.14;
uniform vec4 breath_warm_tint : source_color = vec4(1.10, 0.80, 0.75, 1.0);

// Distorsion de chaleur/humidité — deux samples de gradient noise pour offset UV indépendants en X/Y.
uniform float distortion_strength : hint_range(0.0, 0.05) = 0.012;
uniform float distortion_scale = 3.5;
uniform float distortion_speed = 0.18;

vec2 hash22(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

float gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	float a = dot(hash22(i),                f);
	float b = dot(hash22(i + vec2(1, 0)),   f - vec2(1, 0));
	float c = dot(hash22(i + vec2(0, 1)),   f - vec2(0, 1));
	float d = dot(hash22(i + vec2(1, 1)),   f - vec2(1, 1));
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
	float t = TIME * distortion_speed;
	vec2 warp = vec2(
		gnoise(UV * distortion_scale + vec2(t, 0.0)),
		gnoise(UV * distortion_scale + vec2(0.0, t + 13.0))
	);
	vec2 uv = UV + warp * distortion_strength;

	vec4 base = texture(TEXTURE, uv);

	// Cycle de respiration smooth (smoothstep-like sur sinus)
	float p = 0.5 + 0.5 * sin(TIME * breath_speed);
	float pulse = p * p * (3.0 - 2.0 * p);

	// Brightness ondule autour de 1.0 avec amplitude breath_amount
	float brightness = 1.0 - breath_amount * 0.5 + breath_amount * pulse;

	// Mix de teinte : tint normal au repos, mix vers breath_warm_tint à l'expiration
	vec4 active_tint = mix(tint, breath_warm_tint, pulse * 0.6);

	base.rgb *= brightness;
	base.rgb *= active_tint.rgb;
	base.rgb *= darkness;

	COLOR = vec4(base.rgb, base.a * active_tint.a);
}
