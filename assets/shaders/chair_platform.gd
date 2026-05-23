@tool
extends CanvasItem
class_name ChairPlatform

# Pilote le shader chair_platform.gdshader :
# - quand le joueur atterrit ou marche, appeler trigger_impact()
# - l'intensité décroît automatiquement
#
# Branchement type côté Player.gd :
#   if just_landed:
#       var p := get_node_or_null("/root/LesYeux/SolChair") as ChairPlatform
#       if p: p.trigger_impact(global_position, fall_velocity_y / 600.0)

@export var max_impact_intensity: float = 14.0
@export var step_impact_intensity: float = 4.0
# Combien de temps une bouffée d'intensité met à retomber à zéro (secondes)
@export var decay_time: float = 0.55

var _intensity: float = 0.0
var _decay_speed: float = 0.0


func _ready() -> void:
	# Tu peux laisser les paramètres par défaut OU customiser ici
	_apply("impact_intensity", 0.0)


func _process(delta: float) -> void:
	if _intensity > 0.001:
		_intensity = max(0.0, _intensity - _decay_speed * delta)
		_apply("impact_intensity", _intensity)


# force : 0..1+, 1.0 = atterrissage standard, >1.0 = chute lourde
func trigger_impact(world_position: Vector2, force: float = 1.0) -> void:
	var target := max_impact_intensity * clamp(force, 0.1, 2.0)
	_intensity = max(_intensity, target)
	_decay_speed = _intensity / max(decay_time, 0.05)
	_apply("impact_position", world_position)
	_apply("impact_intensity", _intensity)


# Pour un simple pas (impact plus discret)
func trigger_step(world_position: Vector2) -> void:
	trigger_impact(world_position, step_impact_intensity / max_impact_intensity)


func _apply(name: String, value: Variant) -> void:
	if material is ShaderMaterial:
		(material as ShaderMaterial).set_shader_parameter(name, value)
