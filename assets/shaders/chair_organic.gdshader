// Chair organique procédurale (sans texture externe) : cellules voronoi distordues,
// nervures sombres entre cellules, pulse de respiration, jeu de niveaux noir/bordeaux.
shader_type canvas_item;

uniform vec4 deep_color : source_color = vec4(0.015, 0.005, 0.010, 1.0);
uniform vec4 mid_color : source_color = vec4(0.055, 0.018, 0.022, 1.0);
uniform vec4 ridge_color : source_color = vec4(0.14, 0.04, 0.05, 1.0);
uniform vec4 vein_color : source_color = vec4(0.005, 0.0, 0.002, 1.0);

uniform float scale = 0.0040;
uniform float cell_density = 2.5;
uniform float vein_width : hint_range(0.0, 0.25) = 0.10;

uniform float breath_speed = 0.30;
uniform float breath_amount : hint_range(0.0, 0.4) = 0.10;
uniform float distortion_amount : hint_range(0.0, 1.0) = 0.45;
uniform float distortion_speed = 0.06;
uniform float overall_brightness : hint_range(0.0, 2.0) = 1.0;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 hash22(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return fract(sin(p) * 43758.5453);
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	return mix(mix(hash(i), hash(i + vec2(1, 0)), u.x),
			   mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), u.x), u.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		v += a * gnoise(p);
		p = p * 2.07 + 11.3;
		a *= 0.55;
	}
	return v;
}

// Voronoi qui renvoie (distance bord, hash de la cellule)
vec2 voronoi(vec2 uv) {
	vec2 g = floor(uv);
	vec2 f = fract(uv);
	float d1 = 9.0;
	float d2 = 9.0;
	vec2 cell_id = vec2(0.0);
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 lattice = vec2(float(x), float(y));
			vec2 offset = hash22(g + lattice);
			vec2 r = lattice + offset - f;
			float d = dot(r, r);
			if (d < d1) {
				d2 = d1;
				d1 = d;
				cell_id = g + lattice;
			} else if (d < d2) {
				d2 = d;
			}
		}
	}
	return vec2(sqrt(d2) - sqrt(d1), hash(cell_id));
}

void fragment() {
	vec2 uv = world_pos * scale;

	// Distortion organique humide
	float t = TIME * distortion_speed;
	vec2 warp = vec2(fbm(uv * 1.4 + vec2(t, 0.0)),
					 fbm(uv * 1.4 + vec2(0.0, t + 7.5)));
	uv += warp * distortion_amount;

	vec2 v = voronoi(uv * cell_density);
	float edge_dist = v.x;
	float cell_hash = v.y;

	// Surface interne de chaque cellule
	float surface = fbm(uv * 5.0 + cell_hash * 30.0);

	// Mix deep / mid selon la surface, varie un peu par cellule
	float cell_brightness = 0.7 + 0.6 * cell_hash;
	vec3 inside = mix(deep_color.rgb, mid_color.rgb, surface) * cell_brightness;

	// Approche du bord (entre cellules) : bordure rouge tirée du sang
	float ridge_mask = 1.0 - smoothstep(0.0, vein_width * 1.5, edge_dist);
	vec3 col = mix(inside, ridge_color.rgb, ridge_mask * 0.55);

	// Sillon noir très fin entre cellules (le sang séché entre les chairs)
	float vein_mask = 1.0 - smoothstep(0.0, vein_width * 0.35, edge_dist);
	col = mix(col, vein_color.rgb, vein_mask);

	// Pulse de respiration global (smoothstep sur sinus)
	float p = 0.5 + 0.5 * sin(TIME * breath_speed);
	float pulse = p * p * (3.0 - 2.0 * p);
	col *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;

	col *= overall_brightness;

	COLOR = vec4(col, 1.0);
}
