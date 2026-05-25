// flesh_breathing.gdshader
// Fond de chair de la zone Les Yeux (image unique : chair + cils noirs intégrés).
//
//  - Tâche 3 : la CHAIR respire (zoom UV + luminosité, via TIME), de façon
//    visible mais douce.
//  - Tâche 2 : les CILS (zones noires) ondulent légèrement en continu, et
//    s'écartent de Zell à son passage (sillage), via un décalage d'UV horizontal.
//  - Le noir reste net : détecté par sa luminance (masque "grass").
shader_type canvas_item;

// --- Respiration (chair) ---
uniform float breath_speed : hint_range(0.0, 3.0) = 0.8;
uniform float uv_amount : hint_range(0.0, 0.15) = 0.035;    // amplitude du zoom UV
uniform float bright_amount : hint_range(0.0, 0.6) = 0.20;  // amplitude de luminosité

// --- Séparation chair / noir ---
uniform float flesh_threshold : hint_range(0.0, 0.5) = 0.06;
uniform float flesh_softness : hint_range(0.001, 0.3) = 0.08;

// --- Cils : balancement ambiant + sillage du joueur ---
// player_pos est en UV [0..1] (fourni par BackgroundFlesh.gd) ; hors-champ par défaut.
uniform vec2 player_pos = vec2(-1.0, -1.0);
uniform float wake_radius : hint_range(0.0, 0.5) = 0.10;    // portée du sillage (UV)
uniform float wake_strength : hint_range(0.0, 0.2) = 0.03;  // écartement max (UV)
uniform float sway_speed : hint_range(0.0, 4.0) = 1.2;
uniform float sway_amount : hint_range(0.0, 0.05) = 0.004;

float luminance(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }

void fragment() {
	float pulse = 0.5 + 0.5 * sin(TIME * breath_speed);

	// Masque échantillonné à l'UV d'origine => bords nets.
	vec3 base = texture(TEXTURE, UV).rgb;
	float flesh = smoothstep(flesh_threshold, flesh_threshold + flesh_softness, luminance(base));
	float grass = 1.0 - flesh; // 1 sur le noir (cils), 0 sur la chair

	// 1) Respiration : zoom UV doux, sur la chair seulement.
	vec2 breath_uv = (UV - 0.5) * (1.0 - uv_amount * pulse) + 0.5;
	vec2 final_uv = mix(UV, breath_uv, flesh);

	// 2) Cils : balancement ambiant + sillage qui s'écarte de Zell.
	float sway = sin(UV.x * 40.0 + TIME * sway_speed) * sway_amount;
	float dist = distance(UV, player_pos);
	float infl = smoothstep(wake_radius, 0.0, dist);          // 1 près du joueur
	float dir = sign(UV.x - player_pos.x);                    // pousse à l'opposé
	float wake = dir * wake_strength * infl;
	final_uv.x += (sway + wake) * grass;

	vec3 col = texture(TEXTURE, final_uv).rgb;

	// Luminosité qui respire, chair seulement (le noir reste noir).
	col *= 1.0 + bright_amount * (pulse - 0.5) * 2.0 * flesh;

	COLOR = vec4(col, 1.0);
}
