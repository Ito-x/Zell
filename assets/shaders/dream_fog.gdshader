// dream_fog.gdshader — Brume noire onirique entre les rosaces et le joueur.
// FBM dérivante + warp de domaine + renforcement aux bords Y.
shader_type canvas_item;
uniform vec4 fog_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.9;
uniform float scale : hint_range(0.5, 8.0) = 3.5;
uniform float speed : hint_range(0.0, 0.5) = 0.025;
uniform float warp : hint_range(0.0, 3.0) = 1.6;
uniform float contrast_lo : hint_range(0.0, 1.0) = 0.25;
uniform float contrast_hi : hint_range(0.0, 1.5) = 0.82;
uniform float y_edge_strength : hint_range(0.0, 2.0) = 1.0;
uniform float y_edge_softness : hint_range(0.001, 0.5) = 0.13;
float hash(vec2 p) {
	p = fract(p * vec2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return fract(p.x * p.y);
}
float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}
float fbm(vec2 p) {
	// Optimisation : 3 octaves (vs 5) — gain net en fillrate sur GPU intégré.
	float v = 0.0;
	float amp = 0.5;
	mat2 rot = mat2(vec2(0.8, 0.6), vec2(-0.6, 0.8));
	for (int i = 0; i < 3; i++) {
		v += amp * vnoise(p);
		p = rot * p * 2.0;
		amp *= 0.5;
	}
	return v;
}
void fragment() {
	vec2 fp = UV * scale + vec2(TIME * speed, TIME * speed * 0.4);
	vec2 w = vec2(fbm(fp + vec2(0.0, 1.7)), fbm(fp + vec2(4.2, 0.0)));
	float n = fbm(fp + warp * w);
	n = smoothstep(contrast_lo, contrast_hi, n);
	float dy = abs(UV.y - 0.5) * 2.0;
	float edge = smoothstep(1.0 - y_edge_softness, 1.0, dy);
	float a = clamp(n * density + edge * y_edge_strength * 0.7, 0.0, 1.0);
	COLOR = vec4(fog_color.rgb, a);
}
