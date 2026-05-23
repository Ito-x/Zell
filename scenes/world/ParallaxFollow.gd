@tool
extends Node2D
class_name ParallaxFollow

# Suit la caméra avec un scroll_scale réduit pour donner un effet de parallaxe.
# scroll_scale = 0   → le nœud reste fixe à l'écran
# scroll_scale = 1   → le nœud bouge comme le monde (pas de parallaxe)
# scroll_scale 0.2-0.4 → effet de profondeur, "tout au fond"
@export var scroll_scale: Vector2 = Vector2(0.3, 0.3)
@export var anchor_offset: Vector2 = Vector2.ZERO

var _origin: Vector2

func _ready() -> void:
	_origin = position

func _process(_delta: float) -> void:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return
	var cam_pos := cam.get_screen_center_position()
	# Décalage par rapport à l'origine : 1 - scroll_scale = "à quel point on suit la caméra"
	var lag := cam_pos * (Vector2.ONE - scroll_scale)
	position = _origin + lag + anchor_offset
