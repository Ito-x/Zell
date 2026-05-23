shader_type canvas_item;

uniform sampler2D source_tex : repeat_enable, filter_linear_mipmap;
uniform vec3 stone_tint : source_color = vec3(1.6, 1.35, 0.85);
uniform vec3 vine_tint : source_color = vec3(0.55, 0.45, 0.30);
uniform float texture_scale = 0.0015;
uniform float brightness = 1.0;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 uv = world_pos * texture_scale;
	vec4 tex = texture(source_tex, uv);

	float luma = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	float green_dom = tex.g - max(tex.r, tex.b);

	float vine_mask = smoothstep(0.02, 0.10, green_dom);

	vec3 stone_recolored = vec3(luma) * stone_tint;
	vec3 vine_recolored = vec3(luma) * vine_tint;

	vec3 col = mix(stone_recolored, vine_recolored, vine_mask);
	col *= brightness;

	COLOR = vec4(col, tex.a);
}
