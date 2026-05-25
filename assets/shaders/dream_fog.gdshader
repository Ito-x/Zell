// dream_fog.gdshader
// Volutes de fumée noire qui dérivent en espace-écran. Posées devant les rosaces
// et derrière le joueur, elles épaississent l'atmosphère onirique des Yeux.
// On utilise SCREEN_UV (toujours valide en canvas_item) plutôt que UV pour ne
// pas dépendre d'une texture ni des coordonnées du polygone.
shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.35;
uniform float scale : hint_range(0.5, 8.0) = 2.2;
uniform float speed : hint_range(0.0, 0.5) = 0.03;
uniform float warp : hint_range(0.0, 3.0) = 1.6;
uniform float contrast_lo : hint_range(0.0, 1.0) = 0.30;
uniform float contrast_hi : hint_range(0.0, 1.5) = 0.92;

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
	float v = 0.0;
	float amp = 0.5;
	mat2 rot = mat2(vec2(0.8, 0.6), vec2(-0.6, 0.8));
	for (int i = 0; i < 5; i++) {
		v += amp * vnoise(p);
		p = rot * p * 2.0;
		amp *= 0.5;
	}
	return v;
}

void fragment() {
	vec2 suv = SCREEN_UV;
	// SCREEN_UV en 16:9 → corrige le ratio pour des volutes ~circulaires
	suv.x *= 1.78;

	vec2 fp = suv * scale + vec2(TIME * speed, TIME * speed * 0.4);
	vec2 w = vec2(fbm(fp + vec2(0.0, 1.7)), fbm(fp + vec2(4.2, 0.0)));
	float fogn = fbm(fp + warp * w);
	fogn = smoothstep(contrast_lo, contrast_hi, fogn);

	float alpha = clamp(fogn * density, 0.0, 1.0);
	COLOR = vec4(fog_color.rgb, alpha * fog_color.a);
}
