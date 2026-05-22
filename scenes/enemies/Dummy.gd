extends StaticBody2D

# Cible de test pour valider les coups d'épée.
# Flash blanc + knockback visuel + particules dorées à chaque coup.

const FLASH_DURATION   := 0.08
const FLASH_COLOR      := Color(1.4, 0.25, 0.25, 1.0)  # Rouge vif, très bref → confirme le hit
const KNOCKBACK_OFFSET := 14.0    # Recul visuel (en pixels) à l'impact
const KNOCKBACK_TIME   := 0.18    # Durée du retour en place

@onready var sprite: Polygon2D = $Sprite
@onready var hit_particles: GPUParticles2D = $HitParticles

var flash_timer := 0.0
var base_modulate: Color
var current_tween: Tween


func _ready() -> void:
	base_modulate = sprite.modulate
	$BodyDamage.area_entered.connect(_on_body_damage_area_entered)


func _on_body_damage_area_entered(area: Area2D) -> void:
	# Quand un Hurtbox étranger touche notre corps, on lui inflige des dégâts
	var node: Node = area.get_parent()
	if node == self:
		return
	if node.has_method("take_damage"):
		node.take_damage(1, global_position)


func _process(delta: float) -> void:
	if flash_timer > 0.0:
		flash_timer = maxf(flash_timer - delta, 0.0)
		var t := flash_timer / FLASH_DURATION
		sprite.modulate = base_modulate.lerp(FLASH_COLOR, t)
	else:
		sprite.modulate = base_modulate


# Appelée par la Hitbox du Player quand un coup connecte.
func take_damage(_amount: int, from_position: Vector2) -> void:
	flash_timer = FLASH_DURATION
	_apply_knockback(from_position)
	_burst_particles()


func _apply_knockback(from_position: Vector2) -> void:
	# Calcule la direction du coup (depuis Zell vers le dummy)
	var dir := (global_position - from_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	# Animation du sprite : recul puis retour à la position d'origine
	if current_tween:
		current_tween.kill()
	sprite.position = dir * KNOCKBACK_OFFSET
	current_tween = create_tween()
	current_tween.tween_property(sprite, "position", Vector2.ZERO, KNOCKBACK_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _burst_particles() -> void:
	hit_particles.restart()
