extends Sprite2D
class_name BackgroundFlesh

## Lie la position du joueur au shader du fond de chair (flesh_breathing.gdshader)
## pour le sillage dans les cils. On transmet la position de Zell convertie en
## coordonnées UV [0..1] de la texture, avec un léger lissage (retour doux à l'idle).

@export var player_path: NodePath
@export var follow_speed: float = 10.0

var _player: Node2D
var _tex_size: Vector2 = Vector2.ONE
var _uv := Vector2(-1.0, -1.0)

func _ready() -> void:
	_player = get_node_or_null(player_path) as Node2D
	if texture != null:
		_tex_size = texture.get_size()

func _process(delta: float) -> void:
	var mat := material as ShaderMaterial
	if mat == null or _player == null:
		return
	# to_local annule la position ET l'échelle du sprite => coords en pixels natifs
	# centrés, qu'on ramène en UV.
	var local := to_local(_player.global_position)
	var target := local / _tex_size + Vector2(0.5, 0.5)
	_uv = _uv.lerp(target, clamp(delta * follow_speed, 0.0, 1.0))
	mat.set_shader_parameter("player_pos", _uv)
