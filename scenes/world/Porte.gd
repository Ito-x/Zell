extends Node2D
class_name Porte

# ── Porte interactive de la zone Les Yeux. ──
# Pour cette étape : visuel + halo qui s'allume quand Zell entre dans la zone
# d'interaction, et touche E ("interact") qui déclenche l'ouverture. L'action
# concrète (transition vers Phase 1) sera branchée plus tard ; pour l'instant
# on émet juste le signal `interacted` et on print.

signal interacted

@export var door_color: Color = Color(0.95, 0.78, 0.32)
@export var halo_color: Color = Color(1.0, 0.85, 0.4)
@export var door_size: Vector2 = Vector2(120, 180)

var _player_in_zone: bool = false
var _t: float = 0.0
var _glow: float = 0.0  # 0..1, lerpé vers 1 quand Zell est dans la zone

@onready var _area: Area2D = $InteractZone

func _ready() -> void:
	if _area != null:
		_area.body_entered.connect(_on_body_entered)
		_area.body_exited.connect(_on_body_exited)
	set_process(true)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		_player_in_zone = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		_player_in_zone = false

func _process(delta: float) -> void:
	_t += delta
	var target := 1.0 if _player_in_zone else 0.0
	_glow = lerpf(_glow, target, clampf(delta * 5.0, 0.0, 1.0))
	# On redessine seulement si le halo est actif (économie quand inutile)
	if _glow > 0.01:
		queue_redraw()
	if _player_in_zone and Input.is_action_just_pressed("interact"):
		_interact()

func _interact() -> void:
	print("[Porte] Phase 1 — à venir")
	interacted.emit()

func _draw() -> void:
	var w := door_size.x
	var h := door_size.y
	var top := -h
	var left := -w / 2.0
	var right := w / 2.0
	var center_y := top + h * 0.5
	# Halo lumineux (visible seulement quand _glow > 0)
	if _glow > 0.01:
		var pulse := 0.7 + 0.3 * sin(_t * 3.2)
		var halo_a := _glow * pulse
		for i in 4:
			var f := float(i) / 4.0
			var r := w * (0.7 + f * 0.9)
			var a := halo_a * (1.0 - f) * 0.4
			draw_arc(Vector2(0, center_y), r, 0.0, TAU, 32, Color(halo_color.r, halo_color.g, halo_color.b, a), 2.5)
	# Corps de la porte (sombre)
	draw_rect(Rect2(left, top, w, h), Color(0.10, 0.07, 0.05, 0.95))
	# Cadre doré (épais)
	var border := PackedVector2Array([
		Vector2(left, 0.0),
		Vector2(left, top),
		Vector2(right, top),
		Vector2(right, 0.0),
		Vector2(left, 0.0)
	])
	draw_polyline(border, door_color, 3.0)
	# Ornement central : un œil (référence à la zone Les Yeux)
	var eye_pos := Vector2(0, top + h * 0.45)
	var eye_r := w * 0.20
	draw_arc(eye_pos, eye_r, 0.0, TAU, 36, door_color, 2.0)
	draw_arc(eye_pos, eye_r * 0.5, 0.0, TAU, 24, door_color, 1.5)
	draw_circle(eye_pos, eye_r * 0.18, Color(0.05, 0.03, 0.02))
	# Petite poignée
	draw_circle(Vector2(w * 0.30, top + h * 0.78), 4.0, door_color)
