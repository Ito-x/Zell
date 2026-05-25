shader_type canvas_item;

// Grille prototype pour le fond du hub
uniform vec4 bg_color : source_color = vec4(0.05, 0.08, 0.18, 1.0);
uniform vec4 line_color : source_color = vec4(0.12, 0.18, 0.35, 1.0);
uniform vec4 major_color : source_color = vec4(0.15, 0.22, 0.42, 1.0);
uniform float grid_size = 100.0;
uniform float major_every = 5.0;
uniform float line_width = 1.0;
uniform float major_width = 2.0;
uniform vec2 rect_size = vec2(10000.0, 10000.0);

void fragment() {
	vec2 pos = UV * rect_size;

	// Lignes mineures
	vec2 cell = mod(pos, grid_size);
	float minor = step(cell.x, line_width) + step(cell.y, line_width);
	minor = clamp(minor, 0.0, 1.0);

	// Lignes majeures
	float major_size = grid_size * major_every;
	vec2 major_cell = mod(pos, major_size);
	float major = step(major_cell.x, major_width) + step(major_cell.y, major_width);
	major = clamp(major, 0.0, 1.0);

	vec4 color = bg_color;
	color = mix(color, line_color, minor * 0.5);
	color = mix(color, major_color, major * 0.8);

	COLOR = color;
}
