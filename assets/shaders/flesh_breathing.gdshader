// flesh_breathing.gdshader
// Effet de respiration organique pour le fond de chair de la zone Les Yeux.
//
// Une seule texture (le dessin contient déjà chair + cadre noir/cils).
// La CHAIR respire : léger zoom UV + modulation de luminosité, lents, via TIME.
// Le NOIR (cils / cadre) reste NET et pur : on le détecte par sa luminance et
// on n'y applique ni le zoom UV ni la modulation de luminosité.
shader_type canvas_item;

uniform float breath_speed : hint_range(0.0, 2.0) = 0.25;   // vitesse de la respiration
uniform float uv_amount : hint_range(0.0, 0.1) = 0.012;     // amplitude du zoom (UV)
uniform float bright_amount : hint_range(0.0, 0.5) = 0.10;  // amplitude de luminosité
uniform float flesh_threshold : hint_range(0.0, 0.5) = 0.06;// en dessous = considéré noir
uniform float flesh_softness : hint_range(0.001, 0.3) = 0.08;

float luminance(vec3 c) {
	return dot(c, vec3(0.299, 0.587, 0.114));
}

void fragment() {
	// Onde lente 0→1→0
	float pulse = 0.5 + 0.5 * sin(TIME * breath_speed);

	// Masque chair : 1 sur la chair (claire), 0 sur le noir (cils/cadre).
	// Échantillonné à l'UV d'origine => le bord noir reste parfaitement net.
	vec3 base = texture(TEXTURE, UV).rgb;
	float flesh = smoothstep(flesh_threshold, flesh_threshold + flesh_softness, luminance(base));

	// Zoom UV très léger autour du centre, appliqué seulement là où il y a de la chair.
	vec2 breath_uv = (UV - 0.5) * (1.0 - uv_amount * pulse) + 0.5;
	vec2 final_uv = mix(UV, breath_uv, flesh);

	vec3 col = texture(TEXTURE, final_uv).rgb;

	// Modulation de luminosité ±bright_amount, uniquement sur la chair.
	col *= 1.0 + bright_amount * (pulse - 0.5) * 2.0 * flesh;

	COLOR = vec4(col, 1.0);
}
