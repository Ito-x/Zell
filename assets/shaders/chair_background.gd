@tool
extends CanvasItem
class_name ChairBackground

# Permet de piloter dynamiquement le fond chair depuis le code :
#   $Fond.set_breath_speed(0.6)
#   $Fond.set_tint(Color(1.0, 0.7, 0.7))
#   $Fond.pulse_burst(0.3, 0.5)  -> bouffée d'intensité de respiration

@export var breath_speed: float = 0.4 : set = set_breath_speed
@export var breath_amount: float = 0.14 : set = set_breath_amount
@export var distortion_strength: float = 0.012 : set = set_distortion_strength
@export var tint: Color = Color(1.0, 0.85, 0.82) : set = set_tint
@export var darkness: float = 0.55 : set = set_darkness

var _base_breath_amount: float = 0.14
var _burst_value: float = 0.0
var _burst_decay: float = 0.6


func _ready() -> void:
	_base_breath_amount = breath_amount
	_apply_all()


func _process(delta: float) -> void:
	if _burst_value > 0.001:
		_burst_value = max(0.0, _burst_value - _burst_decay * delta)
		_apply_param("breath_amount", _base_breath_amount + _burst_value)


# Émet une bouffée temporaire de respiration (ex : déclenchée par un événement scénaristique)
func pulse_burst(amount: float, decay: float = 0.6) -> void:
	_burst_value = amount
	_burst_decay = decay


func set_breath_speed(v: float) -> void:
	breath_speed = v
	_apply_param("breath_speed", v)

func set_breath_amount(v: float) -> void:
	breath_amount = v
	_base_breath_amount = v
	_apply_param("breath_amount", v)

func set_distortion_strength(v: float) -> void:
	distortion_strength = v
	_apply_param("distortion_strength", v)

func set_tint(c: Color) -> void:
	tint = c
	_apply_param("tint", c)

func set_darkness(v: float) -> void:
	darkness = v
	_apply_param("darkness", v)


func _apply_all() -> void:
	_apply_param("breath_speed", breath_speed)
	_apply_param("breath_amount", breath_amount)
	_apply_param("distortion_strength", distortion_strength)
	_apply_param("tint", tint)
	_apply_param("darkness", darkness)


func _apply_param(name: String, value: Variant) -> void:
	if material is ShaderMaterial:
		(material as ShaderMaterial).set_shader_parameter(name, value)
