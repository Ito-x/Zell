extends Node2D

@export_enum("persistent", "glimpse", "proximity") var reveal_type: String = "persistent"
@export var reveal_duration := 1.5
@export var proximity_radius := 150.0
@export var detection_radius := 30.0

var is_revealed := false
var reveal_timer := 0.0
var shimmer_active := false
var parent_node: CanvasItem
var player_ref: Node2D
var reveal_tween: Tween
var detection_area: Area2D


func _ready() -> void:
	parent_node = get_parent() as CanvasItem
	if parent_node:
		parent_node.modulate.a = 0.0
	_create_detection_area()


func _create_detection_area() -> void:
	detection_area = Area2D.new()
	detection_area.collision_layer = 16
	detection_area.collision_mask = 0
	detection_area.monitorable = true
	detection_area.monitoring = false
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = detection_radius
	shape.shape = circle
	detection_area.add_child(shape)
	add_child(detection_area)


func _process(delta: float) -> void:
	if not is_revealed:
		if shimmer_active:
			_update_shimmer()
		return

	match reveal_type:
		"glimpse":
			reveal_timer -= delta
			if reveal_timer <= 0.0:
				_hide()
		"proximity":
			if player_ref:
				var dist: float = player_ref.global_position.distance_to(global_position)
				if dist > proximity_radius:
					_hide()


func reveal(distance_from_player: float, player: Node2D = null) -> void:
	if is_revealed:
		return
	player_ref = player
	is_revealed = true
	shimmer_active = false

	match reveal_type:
		"persistent":
			_show()
		"glimpse":
			if distance_from_player < proximity_radius:
				reveal_type = "persistent"
				_show()
			else:
				reveal_timer = reveal_duration
				_show()
		"proximity":
			_show()


func _show() -> void:
	if not parent_node:
		return
	if reveal_tween:
		reveal_tween.kill()
	reveal_tween = create_tween()
	reveal_tween.tween_property(parent_node, "modulate:a", 1.0, 0.15)


func _hide() -> void:
	is_revealed = false
	if not parent_node:
		return
	if reveal_tween:
		reveal_tween.kill()
	reveal_tween = create_tween()
	reveal_tween.tween_property(parent_node, "modulate:a", 0.0, 0.3)
	reveal_tween.tween_callback(func() -> void: shimmer_active = true)


func _update_shimmer() -> void:
	if not parent_node:
		return
	var t := Time.get_ticks_msec() / 1000.0
	parent_node.modulate.a = 0.05 + 0.10 * abs(sin(t * 3.0))
