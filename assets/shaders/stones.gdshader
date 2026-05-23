shader_type canvas_item;

uniform vec3 stone_color : source_color = vec3(0.32, 0.27, 0.20);
uniform vec3 crack_color : source_color = vec3(0.04, 0.03, 0.02);
uniform vec3 highlight_color : source_color = vec3(0.50, 0.43, 0.32);
uniform float scale = 0.015;
uniform float crack_width : hint_range(0.01, 0.15) = 0.05;
uniform float color_variation : hint_range(0.0, 0.6) = 0.35;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 hash2(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return fract(sin(p) * 43758.5453);
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1, 0)), f.x),
			   mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), f.x), f.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 4; i++) {
		v += a * noise(p);
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

void fragment() {
	vec2 uv = world_pos * scale;
	// Distorsion pour casser la grille voronoi
	uv += vec2(fbm(uv * 3.0), fbm(uv * 3.0 + 17.0)) * 0.15;

	vec2 g = floor(uv);
	vec2 f = fract(uv);
	float d1 = 9.0;
	float d2 = 9.0;
	vec2 cell_id = vec2(0.0);
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 lattice = vec2(float(x), float(y));
			vec2 offset = hash2(g + lattice);
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
	float edge = sqrt(d2) - sqrt(d1);
	float crack = smoothstep(0.0, crack_width, edge);

	float cell_h = hash(cell_id);
	float surface = fbm(uv * 6.0 + cell_h * 20.0);
	float detail = fbm(uv * 18.0 + cell_h * 50.0);

	vec3 stone_var = stone_color * (1.0 - color_variation * 0.5 + color_variation * cell_h);
	vec3 col = mix(stone_var * 0.55, stone_var, surface);
	col = mix(col, highlight_color, smoothstep(0.65, 0.9, surface) * 0.35);
	col *= 0.85 + 0.3 * detail;

	col = mix(crack_color, col, crack);

	COLOR = vec4(col, 1.0);
}
