extends Area2D

const EXPAND_DURATION := 1.5
const MAX_RADIUS := 400.0

var revealed_targets := []
var player_position := Vector2.ZERO
var shape_ref: CircleShape2D
var wave_tween: Tween


func _ready() -> void:
	shape_ref = $CollisionShape2D.shape.duplicate() as CircleShape2D
	shape_ref.radius = 0.01
	$CollisionShape2D.shape = shape_ref

	var mat: ShaderMaterial = $WaveVisual.material as ShaderMaterial
	if mat:
		mat = mat.duplicate() as ShaderMaterial
		$WaveVisual.material = mat
		mat.set_shader_parameter("ring_radius", 0.0)
		mat.set_shader_parameter("alpha_multiplier", 1.0)

	wave_tween = create_tween().set_parallel(true)
	wave_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	wave_tween.tween_method(_set_radius, 0.0, MAX_RADIUS, EXPAND_DURATION)
	if mat:
		wave_tween.tween_method(
			func(v: float) -> void: mat.set_shader_parameter("ring_radius", v),
			0.0, 1.0, EXPAND_DURATION
		)
		wave_tween.tween_property(mat, "shader_parameter/alpha_multiplier", 0.0, EXPAND_DURATION)
	wave_tween.chain().tween_callback(queue_free)


func _physics_process(_delta: float) -> void:
	for area: Area2D in get_overlapping_areas():
		var revealable_node: Node = area.get_parent()
		if revealable_node in revealed_targets:
			continue
		if not revealable_node.has_method("reveal"):
			continue
		revealed_targets.append(revealable_node)
		var dist: float = revealable_node.global_position.distance_to(player_position)
		var player: Node2D = null
		var players := get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0] as Node2D
		revealable_node.reveal(dist, player)


func _set_radius(value: float) -> void:
	shape_ref.radius = maxf(value, 0.01)
