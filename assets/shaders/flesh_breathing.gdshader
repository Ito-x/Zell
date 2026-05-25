// flesh_breathing.gdshader
// Fond de chair de la zone Les Yeux (image unique : chair + cils noirs intégrés).
//
//  - Tâche 3 : la CHAIR respire (zoom UV + luminosité, via TIME).
//  - Tâche 2 : les CILS (zones noires) ondulent et s'écartent de Zell (sillage).
//  - Fog noir : vraie brume fluide (fbm + warp de domaine) qui dérive sur la
//    chair, en épargnant les cils (via le masque "flesh").
shader_type canvas_item;

// --- Respiration (chair) ---
uniform float breath_speed : hint_range(0.0, 3.0) = 0.8;
uniform float uv_amount : hint_range(0.0, 0.15) = 0.035;
uniform float bright_amount : hint_range(0.0, 0.6) = 0.20;
uniform float flesh_darken : hint_range(0.0, 1.0) = 0.35;

// --- Fog noir (brume fluide sur la chair) ---
uniform vec4 fog_color : source_color = vec4(0.01, 0.006, 0.02, 1.0);
uniform float fog_density : hint_range(0.0, 1.0) = 0.75;
uniform float fog_scale : hint_range(0.5, 8.0) = 3.0;
uniform float fog_speed : hint_range(0.0, 0.5) = 0.02;
uniform float fog_warp : hint_range(0.0, 3.0) = 1.4;        // déforme le bruit => volutes
uniform float fog_contrast_lo : hint_range(0.0, 1.0) = 0.2;
uniform float fog_contrast_hi : hint_range(0.0, 1.5) = 1.0;

// --- Séparation chair / noir ---
uniform float flesh_threshold : hint_range(0.0, 0.5) = 0.06;
uniform float flesh_softness : hint_range(0.001, 0.3) = 0.08;

// --- Cils : balancement ambiant + sillage du joueur ---
uniform vec2 player_pos = vec2(-1.0, -1.0);
uniform float wake_radius : hint_range(0.0, 0.5) = 0.10;
uniform float wake_strength : hint_range(0.0, 0.2) = 0.03;
uniform float sway_speed : hint_range(0.0, 4.0) = 1.2;
uniform float sway_amount : hint_range(0.0, 0.05) = 0.004;

float luminance(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }

// Hash 2D peu directionnel (style iq).
float hash(vec2 p) {
	p = fract(p * vec2(123.34, 345.45));
	p += dot(p, p + 34.345);
	return fract(p.x * p.y);
}

// Bruit de valeur avec interpolation quintique (lisse, sans cassures de grille).
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

// fbm : octaves tournées (anti-alignement sur les axes => pas de cubes).
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
	float pulse = 0.5 + 0.5 * sin(TIME * breath_speed);

	// Masque échantillonné à l'UV d'origine => bords nets.
	vec3 base = texture(TEXTURE, UV).rgb;
	float flesh = smoothstep(flesh_threshold, flesh_threshold + flesh_softness, luminance(base));
	float grass = 1.0 - flesh;

	// 1) Respiration : zoom UV doux, chair seulement.
	vec2 breath_uv = (UV - 0.5) * (1.0 - uv_amount * pulse) + 0.5;
	vec2 final_uv = mix(UV, breath_uv, flesh);

	// 2) Cils : balancement ambiant + sillage qui s'écarte de Zell.
	float sway = sin(UV.x * 40.0 + TIME * sway_speed) * sway_amount;
	float d = distance(UV, player_pos);
	float infl = smoothstep(wake_radius, 0.0, d);
	float dir = sign(UV.x - player_pos.x);
	float wake = dir * wake_strength * infl;
	final_uv.x += (sway + wake) * grass;

	vec3 col = texture(TEXTURE, final_uv).rgb;

	// Luminosité qui respire, chair seulement.
	col *= 1.0 + bright_amount * (pulse - 0.5) * 2.0 * flesh;

	// Assombrissement de base de la chair.
	col *= mix(1.0, 1.0 - flesh_darken, flesh);

	// 3) Fog noir fluide : fbm dérivant + warp de domaine pour des volutes.
	vec2 fp = UV * fog_scale + vec2(TIME * fog_speed, TIME * fog_speed * 0.4);
	vec2 warp = vec2(fbm(fp + vec2(0.0, 1.7)), fbm(fp + vec2(4.2, 0.0)));
	float fogn = fbm(fp + fog_warp * warp);
	fogn = smoothstep(fog_contrast_lo, fog_contrast_hi, fogn);
	float fog_amt = fogn * fog_density * flesh;
	col = mix(col, fog_color.rgb, fog_amt);

	COLOR = vec4(col, 1.0);
}
