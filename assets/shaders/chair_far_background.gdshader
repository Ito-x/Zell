// Shader A — Far background : texture chair rouge poussée vers le noir,
// le contraste interne du pattern est préservé pour rester subtilement visible.
shader_type canvas_item;

uniform sampler2D source_tex : filter_linear_mipmap, repeat_enable;
uniform float tex_scale = 0.00055;

// La couleur finale = (texture × tint) très assombrie
uniform vec3 tint : source_color = vec3(0.22, 0.05, 0.04);
uniform float darkness : hint_range(0.0, 1.0) = 0.16;

// contrast > 1 : pousse les pixels sombres encore plus dans le noir,
// les pixels lumineux gardent leur valeur → contraste préservé même très sombre.
uniform float contrast : hint_range(0.5, 5.0) = 2.2;

// Pulse organique très lent pour suggérer une masse vivante au loin.
uniform float breath_speed : hint_range(0.0, 2.0) = 0.14;
uniform float breath_amount : hint_range(0.0, 0.3) = 0.05;

// Distortion très subtile (vague de chaleur)
uniform float distortion_strength : hint_range(0.0, 0.02) = 0.004;
uniform float distortion_speed = 0.04;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

vec2 hash22(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}

float gnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	float a = dot(hash22(i),                f);
	float b = dot(hash22(i + vec2(1, 0)),   f - vec2(1, 0));
	float c = dot(hash22(i + vec2(0, 1)),   f - vec2(0, 1));
	float d = dot(hash22(i + vec2(1, 1)),   f - vec2(1, 1));
	return 0.5 + 0.5 * mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
	float t = TIME * distortion_speed;
	vec2 warp = vec2(gnoise(world_pos * tex_scale * 4.0 + vec2(t, 0.0)),
					 gnoise(world_pos * tex_scale * 4.0 + vec2(0.0, t + 11.0)));

	vec2 uv = world_pos * tex_scale + (warp - 0.5) * distortion_strength;

	vec4 src = texture(source_tex, uv);

	// Préserve le contraste : pow sur la luminance, multiplie par tint
	float lum = dot(src.rgb, vec3(0.299, 0.587, 0.114));
	float lum_c = pow(lum, contrast);

	vec3 col = tint * lum_c;
	col *= darkness;

	// Pulse global très subtil
	float p = 0.5 + 0.5 * sin(TIME * breath_speed);
	float pulse = p * p * (3.0 - 2.0 * p);
	col *= 1.0 - breath_amount * 0.5 + breath_amount * pulse;

	COLOR = vec4(col, 1.0);
}
