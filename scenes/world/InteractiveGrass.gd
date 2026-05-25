extends Polygon2D
class_name InteractiveGrass

## Tâche 4 — Herbe / cils interactifs.
##
## À attacher sur un Polygon2D dont le material utilise grass_silhouette.gdshader.
## Chaque frame, on transmet au shader la position du joueur convertie dans
## l'espace LOCAL de ce nœud (to_local), via le paramètre per-instance "player_pos".
## Les brins se courbent à l'approche de Zell, puis reviennent doucement à l'idle
## (le vent d'ambiance, lui, est géré tout seul par le shader avec TIME).

## Chemin vers le joueur. Si vide, on cherche le 1er nœud du groupe "player".
@export var player_path: NodePath

## Vitesse de lissage du retour à l'idle (plus haut = réaction plus sèche).
@export var follow_speed: float = 12.0

const FAR := Vector2(99999.0, 99999.0)  # "pas de joueur" => aucune déformation

var _player: Node2D
var _smoothed := FAR

func _ready() -> void:
	if player_path != NodePath():
		_player = get_node_or_null(player_path) as Node2D
	if _player == null:
		var nodes := get_tree().get_nodes_in_group("player")
		if not nodes.is_empty():
			_player = nodes[0] as Node2D
	# Sécurité : sans material shader, le script ne sert à rien.
	if material == null or not (material is ShaderMaterial):
		push_warning("InteractiveGrass : ce nœud n'a pas de ShaderMaterial (grass_silhouette).")
		set_process(false)

func _process(delta: float) -> void:
	var mat := material as ShaderMaterial
	if mat == null:
		return
	# Cible = joueur en coords locales, sinon très loin (=> l'herbe se redresse).
	var target := FAR
	if is_instance_valid(_player):
		target = to_local(_player.global_position)
	# Lissage exponentiel borné pour un easing propre, indépendant du framerate.
	_smoothed = _smoothed.lerp(target, clamp(delta * follow_speed, 0.0, 1.0))
	mat.set_shader_parameter("player_pos", _smoothed)
