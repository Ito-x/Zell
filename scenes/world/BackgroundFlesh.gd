extends Sprite2D
class_name BackgroundFlesh
## Lie la position du joueur au shader du fond de chair pour le sillage dans
## les cils. On transmet aussi player_pos à l'overlay des herbes (s'il est
## câblé) pour rester parfaitement synchro avec le fond.
@export var player_path: NodePath
@export var follow_speed: float = 10.0
## Overlay des herbes (Sprite2D devant les rosaces). Reçoit le même player_pos.
@export var grass_overlay_path: NodePath
var _player: Node2D
var _tex_size: Vector2 = Vector2.ONE
var _uv := Vector2(-1.0, -1.0)
var _overlay: CanvasItem
func _ready() -> void:
	_player = get_node_or_null(player_path) as Node2D
	if texture != null:
		_tex_size = texture.get_size()
	_overlay = get_node_or_null(grass_overlay_path) as CanvasItem
func _process(delta: float) -> void:
	var mat := material as ShaderMaterial
	if mat == null or _player == null:
		return
	var local := to_local(_player.global_position)
	var target := local / _tex_size + Vector2(0.5, 0.5)
	_uv = _uv.lerp(target, clamp(delta * follow_speed, 0.0, 1.0))
	mat.set_shader_parameter("player_pos", _uv)
	if _overlay != null:
		var omat := _overlay.material as ShaderMaterial
		if omat != null:
			omat.set_shader_parameter("player_pos", _uv)
