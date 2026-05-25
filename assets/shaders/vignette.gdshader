// vignette.gdshader
// Brume sombre / vignette d'ambiance (Tâche 4).
// Transparente au centre, s'assombrit doucement vers les bords pour la profondeur.
// Reste translucide (alpha modéré) => n'écrase pas la chair ni les cils.
// À mettre sur un ColorRect plein écran, dans un CanvasLayer au-dessus de la scène.
shader_type canvas_item;

uniform vec4 fog_color : source_color = vec4(0.015, 0.008, 0.025, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 0.40;   // opacité max aux coins
uniform float inner : hint_range(0.0, 1.5) = 0.45;      // rayon début d'assombrissement
uniform float outer : hint_range(0.0, 1.5) = 1.15;      // rayon opacité max
uniform float pulse_speed : hint_range(0.0, 1.0) = 0.05;

void fragment() {
	// r = 0 au centre, ~1.41 aux coins.
	float r = length(UV - 0.5) * 2.0;
	// Respiration très lente de la brume.
	float breathe = 0.92 + 0.08 * sin(TIME * pulse_speed * 6.2831853);
	float v = smoothstep(inner, outer, r) * breathe;
	COLOR = vec4(fog_color.rgb, v * strength);
}
