shader_type canvas_item;

uniform float ring_radius : hint_range(0.0, 1.0) = 0.0;
uniform float ring_thickness : hint_range(0.0, 0.1) = 0.03;
uniform float alpha_multiplier : hint_range(0.0, 1.0) = 1.0;
uniform vec4 color_inner : source_color = vec4(1.0, 0.85, 0.35, 1.0);
uniform vec4 color_outer : source_color = vec4(0.35, 0.65, 1.0, 1.0);

void fragment() {
	vec2 centered = UV - vec2(0.5);
	float dist = length(centered) * 2.0;
	float inner_edge = ring_radius - ring_thickness;
	float outer_edge = ring_radius + ring_thickness;
	float ring_mask = smoothstep(inner_edge - 0.01, inner_edge, dist)
	               * (1.0 - smoothstep(outer_edge, outer_edge + 0.01, dist));
	float t = clamp((dist - inner_edge) / max(outer_edge - inner_edge, 0.001), 0.0, 1.0);
	vec4 col = mix(color_inner, color_outer, t);
	col.a *= ring_mask * alpha_multiplier;
	COLOR = col;
}
