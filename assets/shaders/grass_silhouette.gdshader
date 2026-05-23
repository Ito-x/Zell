// Silhouettes d'herbe / stalactites procédurales en noir.
// À placer en bord de sol (tip_dir = -1, brins pointent vers le haut)
// ou en bord de plafond (tip_dir = +1, brins pointent vers le bas).
shader_type canvas_item;

uniform vec4 grass_color : source_color = vec4(0.018, 0.018, 0.026, 1.0);

// -1 = pointes vers -Y (sol, herbe pousse vers le haut)
// +1 = pointes vers +Y (plafond, stalactites pendent vers le bas)
uniform float tip_dir : hint_range(-1.0, 1.0) = -1.0;
uniform float zone_height = 140.0;

uniform float wind_speed : hint_range(0.0, 3.0) = 0.5;
uniform float wind_amount : hint_range(0.0, 30.0) = 8.0;

// Couche dense (brins courts/moyens)
uniform float blade_spacing = 14.0;
uniform float blade_thickness = 4.5;
uniform float blade_min_height : hint_range(0.1, 1.0) = 0.30;
uniform float blade_max_height : hint_range(0.3, 1.0) = 0.90;

// Couche éparse (brins longs au premier plan)
uniform float long_blade_spacing = 80.0;
uniform float long_blade_thickness = 6.0;
uniform float long_blade_min_height : hint_range(0.4, 1.0) = 0.75;
uniform float long_blade_max_height : hint_range(0.6, 1.2) = 1.05;

varying vec2 local_pos;

void vertex() {
	local_pos = VERTEX;
}

float hash11(float x) {
	return fract(sin(x * 12.9898) * 43758.5453);
}

float blade_alpha(float x, float y_norm, float spacing, float thickness,
				  float h_min, float h_max, float wind_phase_mul, float wind_mul) {
	float in_blade = 0.0;
	for (int i = -1; i <= 1; i++) {
		float cell = floor(x / spacing) + float(i);
		float seed_x = hash11(cell * 3.13 + wind_phase_mul);
		float blade_x = (cell + seed_x) * spacing;

		float wind_phase = cell * 1.7 + wind_phase_mul;
		float wind = sin(TIME * wind_speed + wind_phase) * wind_amount * wind_mul;
		// Le vent décale la pointe quadratiquement (la base ne bouge pas)
		blade_x += wind * y_norm * y_norm;

		float seed_h = hash11(cell * 7.71 + wind_phase_mul * 2.3);
		float h_ratio = mix(h_min, h_max, seed_h);

		if (y_norm < h_ratio) {
			float taper = 1.0 - y_norm / h_ratio;
			float w = thickness * taper;
			float dx = abs(x - blade_x);
			float a = smoothstep(w, w * 0.25, dx);
			in_blade = max(in_blade, a);
		}
	}
	return in_blade;
}

void fragment() {
	float x = local_pos.x;
	// Le polygon est placé tel que local Y=0 est la base de l'herbe
	// y_norm = 0 à la base, 1 à la pointe.
	float y_norm = -local_pos.y * tip_dir / zone_height;

	if (y_norm < 0.0 || y_norm > 1.2) {
		COLOR = vec4(grass_color.rgb, 0.0);
	} else {
		float a1 = blade_alpha(x, y_norm, blade_spacing, blade_thickness,
							   blade_min_height, blade_max_height, 0.0, 1.0);
		float a2 = blade_alpha(x, y_norm, long_blade_spacing, long_blade_thickness,
							   long_blade_min_height, long_blade_max_height, 17.3, 1.4);
		float a = max(a1, a2);
		COLOR = vec4(grass_color.rgb, a * grass_color.a);
	}
}
