shader_type canvas_item;

uniform vec4 sparkle_color : source_color = vec4(1.0, 0.95, 0.75, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.45;
uniform float twinkle_speed = 0.5;
uniform float cell_size = 55.0;
uniform float sparkle_radius : hint_range(0.01, 0.15) = 0.06;
uniform float cross_strength : hint_range(0.0, 1.0) = 0.35;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 hash2(vec2 p) {
	return vec2(hash(p), hash(p + 17.0));
}

void fragment() {
	vec2 uv = world_pos / cell_size;
	vec2 grid = floor(uv);
	vec2 local = fract(uv) - 0.5;

	vec2 sparkle_pos = (hash2(grid) - 0.5) * 0.7;
	float exists = step(1.0 - density, hash(grid + 31.0));

	float phase = hash(grid + 73.0) * 6.2831;
	float life_speed = 0.4 + 0.7 * hash(grid + 113.0);
	float twinkle = 0.5 + 0.5 * sin(TIME * twinkle_speed * life_speed + phase);
	twinkle = pow(twinkle, 5.0);

	vec2 d = local - sparkle_pos;
	float dist = length(d);
	float core = smoothstep(sparkle_radius, 0.0, dist);

	// Croix subtile d'étincelle (effet diamant)
	float cross_h = smoothstep(0.003, 0.0, abs(d.y)) * smoothstep(sparkle_radius * 2.0, 0.0, abs(d.x));
	float cross_v = smoothstep(0.003, 0.0, abs(d.x)) * smoothstep(sparkle_radius * 2.0, 0.0, abs(d.y));

	float intensity = (core + (cross_h + cross_v) * cross_strength) * twinkle * exists;

	COLOR = vec4(sparkle_color.rgb, clamp(intensity, 0.0, 1.0) * sparkle_color.a);
}
