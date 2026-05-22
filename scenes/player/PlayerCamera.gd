extends Camera2D

# ---- Look-ahead horizontal ----
const LOOKAHEAD_DISTANCE := 60.0   # Décalage max de la caméra dans le sens du mouvement
const LOOKAHEAD_SPEED    := 3.0    # Vitesse à laquelle la caméra glisse vers le décalage

# ---- Camera shake ----
var shake_intensity := 0.0
var shake_duration  := 0.0
var shake_timer     := 0.0

@onready var player: CharacterBody2D = get_parent()


func _process(delta: float) -> void:
	_update_lookahead(delta)
	_update_shake(delta)


func _update_lookahead(delta: float) -> void:
	# Décale la caméra dans le sens où Zell se déplace (anticipe son intention)
	var target_x := 0.0
	if absf(player.velocity.x) > 20.0:
		target_x = signf(player.velocity.x) * LOOKAHEAD_DISTANCE
	offset.x = lerpf(offset.x, target_x, LOOKAHEAD_SPEED * delta)


func _update_shake(delta: float) -> void:
	if shake_timer <= 0.0:
		offset.y = lerpf(offset.y, 0.0, 10.0 * delta)
		return
	shake_timer -= delta
	# Intensité qui décroît progressivement
	var current_intensity := shake_intensity * (shake_timer / shake_duration)
	offset.x += randf_range(-current_intensity, current_intensity)
	offset.y = randf_range(-current_intensity, current_intensity)


# Appelable depuis n'importe où : ex. camera.shake(8.0, 0.3) au boss hit
func shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration  = duration
	shake_timer     = duration
