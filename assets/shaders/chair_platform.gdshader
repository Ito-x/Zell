// Sol / plateforme chair-tapis avec bourrelets — Normal Map + squash sur impact.
// À utiliser sur Sprite2D / Polygon2D / TileMap dont la "texture" est un CanvasTexture
// (diffuse + normal_texture configurés dans l'inspecteur).
shader_type canvas_item;

// --- Aspect du relief ---
uniform float normal_strength : hint_range(0.0, 2.5) = 1.2;
// depth_contrast : accentue le self-shadow dans les creux des bourrelets (Z bas)
uniform float depth_contrast : hint_range(0.3, 4.0) = 1.6;
uniform float cavity_darkness : hint_range(0.0, 0.9) = 0.55;
// rugosité visuelle : modulation locale du diffuse via le canal Z de la normale
uniform float roughness : hint_range(0.0, 1.5) = 0.4;
uniform vec4 tint : source_color = vec4(1.0, 0.92, 0.85, 1.0);

// --- Squash & stretch / vibration locale ---
// impact_position est en world space ; le script GDScript ci-joint le set au global_position du joueur.
uniform vec2 impact_position = vec2(0.0, 0.0);
uniform float impact_intensity : hint_range(0.0, 30.0) = 0.0;
uniform float impact_radius : hint_range(20.0, 600.0) = 220.0;
uniform float impact_falloff : hint_range(1.0, 6.0) = 2.6;
uniform float vibration_speed : hint_range(2.0, 30.0) = 9.0;
uniform float wave_frequency : hint_range(0.005, 0.10) = 0.028;

varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

// Onde radiale qui s'estompe depuis impact_position
vec2 squash_uv_offset() {
	vec2 d = world_pos - impact_position;
	float dist = length(d);
	float radial = max(0.0, 1.0 - dist / impact_radius);
	float falloff = pow(radial, impact_falloff);
	float wave = sin(TIME * vibration_speed - dist * wave_frequency) * falloff;
	vec2 dir = dist > 0.001 ? d / dist : vec2(0.0, -1.0);
	// Décalage = -dir × onde (la chair compresse vers le point d'impact)
	return -dir * wave * impact_intensity;
}

void fragment() {
	// Squash : décalage UV proportionnel à TEXTURE_PIXEL_SIZE pour rester texture-agnostique
	vec2 offset_world = squash_uv_offset();
	vec2 uv = UV + offset_world * TEXTURE_PIXEL_SIZE;

	// Albedo (diffuse du CanvasTexture)
	vec4 albedo = texture(TEXTURE, uv) * tint;

	// Normale (depuis le normal_texture du CanvasTexture, exposé automatiquement)
	vec3 n_sample = texture(NORMAL_TEXTURE, uv).rgb;
	vec3 n = n_sample * 2.0 - 1.0;
	n.xy *= normal_strength;
	n = normalize(n);

	// Self-shadowing dans les creux : Z-bas (creux) = sombre, Z-haut (sommets) = clair
	float cavity = pow(clamp(n.z, 0.0, 1.0), depth_contrast);
	albedo.rgb *= mix(cavity_darkness, 1.0, cavity);

	// Rugosité visuelle : variation diffuse fine (sans toucher au lighting)
	float micro = (n_sample.x + n_sample.y) * 0.5;
	albedo.rgb *= 1.0 + (micro - 0.5) * roughness * 0.4;

	COLOR = albedo;
	// Renvoie la normale modifiée à Godot → les Light2D l'utilisent automatiquement
	NORMAL = n;
}
