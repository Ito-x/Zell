// grass_overlay.gdshader — Lit la même texture que le background, mais ne sort
// QUE les cils/herbes (zones sombres) avec alpha = grass. Placé devant les
// rosaces, il les masque proprement quand elles passent dans l'herbe.
shader_type canvas_item;
uniform float flesh_threshold : hint_range(0.0, 0.5) = 0.06;
uniform float flesh_softness  : hint_range(0.001, 0.3) = 0.08;
uniform vec2 player_pos = vec2(-1.0, -1.0);
uniform float wake_radius   : hint_range(0.0, 0.5)  = 0.10;
uniform float wake_strength : hint_range(0.0, 0.2)  = 0.03;
uniform float sway_speed    : hint_range(0.0, 4.0)  = 1.2;
uniform float sway_amount   : hint_range(0.0, 0.05) = 0.004;
float luminance(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }
void fragment() {
	vec3 base = texture(TEXTURE, UV).rgb;
	float flesh = smoothstep(flesh_threshold, flesh_threshold + flesh_softness, luminance(base));
	float grass = 1.0 - flesh;
	vec2 final_uv = UV;
	float sway = sin(UV.x * 40.0 + TIME * sway_speed) * sway_amount;
	float d = distance(UV, player_pos);
	float infl = smoothstep(wake_radius, 0.0, d);
	float dir = sign(UV.x - player_pos.x);
	float wake = dir * wake_strength * infl;
	final_uv.x += (sway + wake) * grass;
	vec3 col = texture(TEXTURE, final_uv).rgb;
	COLOR = vec4(col, grass);
}
