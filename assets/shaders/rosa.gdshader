shader_type canvas_item;

uniform float line_width : hint_range(0.005, 0.05) = 0.018;
uniform float petals = 8.0;
uniform float inner_petals = 12.0;

varying vec2 local_pos;
varying vec4 vert_color;

void vertex() {
	local_pos = VERTEX;
	vert_color = COLOR;
}

float line(float dist, float w) {
	return smoothstep(w, 0.0, abs(dist));
}

void fragment() {
	// local_pos va de -30 à +30 (taille fixe du quad). Normalise en -1..1.
	vec2 uv = local_pos / 30.0;
	float r = length(uv);
	float a = atan(uv.y, uv.x);

	float alpha = 0.0;

	// Cercle extérieur
	alpha = max(alpha, line(r - 0.95, line_width));
	// Cercle médian
	alpha = max(alpha, line(r - 0.65, line_width));
	// Cercle intérieur
	alpha = max(alpha, line(r - 0.30, line_width));
	// Cœur
	alpha = max(alpha, line(r - 0.08, line_width));

	// Pétales extérieurs (cardioïde-like)
	float petal_r = 0.80 + 0.15 * cos(a * petals);
	float in_ring_ext = step(0.65, r) * step(r, 0.98);
	alpha = max(alpha, line(r - petal_r, line_width * 0.8) * in_ring_ext);

	// Pétales intérieurs
	float petal_r2 = 0.45 + 0.20 * cos(a * inner_petals + 0.4);
	float in_ring_mid = step(0.30, r) * step(r, 0.68);
	alpha = max(alpha, line(r - petal_r2, line_width * 0.8) * in_ring_mid);

	// Rayons radiaux (lignes droites entre cercle central et médian)
	float radial = step(0.30, r) * step(r, 0.65);
	float angle_lines = abs(sin(a * petals / 2.0));
	alpha = max(alpha, smoothstep(line_width * 1.5, 0.0, angle_lines) * radial);

	// Clamp au disque
	alpha *= step(r, 1.0);

	COLOR = vec4(vert_color.rgb, alpha * vert_color.a);
}
