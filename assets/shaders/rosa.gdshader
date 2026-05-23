shader_type canvas_item;

uniform float line_width : hint_range(0.005, 0.05) = 0.018;
uniform float petals = 8.0;
uniform float inner_petals = 12.0;
uniform float ring_outer = 0.95;
uniform float ring_mid = 0.65;
uniform float ring_inner = 0.30;
uniform float ring_core = 0.08;
uniform float petal_amplitude = 0.15;
uniform float inner_petal_amplitude = 0.20;
uniform float show_outer_petals = 1.0;
uniform float show_inner_petals = 1.0;
uniform float show_radials = 1.0;
uniform float show_ring_mid = 1.0;
uniform float show_ring_inner = 1.0;
uniform float show_core = 1.0;

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
	vec2 uv = local_pos / 30.0;
	float r = length(uv);
	float a = atan(uv.y, uv.x);

	float alpha = 0.0;

	alpha = max(alpha, line(r - ring_outer, line_width));
	alpha = max(alpha, line(r - ring_mid, line_width) * show_ring_mid);
	alpha = max(alpha, line(r - ring_inner, line_width) * show_ring_inner);
	alpha = max(alpha, line(r - ring_core, line_width) * show_core);

	float petal_r = (ring_outer - 0.15) + petal_amplitude * cos(a * petals);
	float in_ring_ext = step(ring_mid, r) * step(r, ring_outer + 0.03);
	alpha = max(alpha, line(r - petal_r, line_width * 0.8) * in_ring_ext * show_outer_petals);

	float petal_r2 = (ring_inner + 0.15) + inner_petal_amplitude * cos(a * inner_petals + 0.4);
	float in_ring_mid = step(ring_inner, r) * step(r, ring_mid + 0.03);
	alpha = max(alpha, line(r - petal_r2, line_width * 0.8) * in_ring_mid * show_inner_petals);

	float radial = step(ring_inner, r) * step(r, ring_mid);
	float angle_lines = abs(sin(a * petals / 2.0));
	alpha = max(alpha, smoothstep(line_width * 1.5, 0.0, angle_lines) * radial * show_radials);

	alpha *= step(r, 1.0);

	COLOR = vec4(vert_color.rgb, alpha * vert_color.a);
}
