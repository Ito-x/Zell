extends Node2D
## Anime les jambes-bâton de Zell : repos quand il est immobile, petit cycle de
## marche (la pointe de chaque jambe balance + se lève) quand il se déplace au sol.
## Seule la POINTE bouge ; la hanche reste accrochée à l'orbe (attache fluide).

@onready var _leg_left: Line2D = $LegLeft
@onready var _leg_right: Line2D = $LegRight
@onready var _body: CharacterBody2D = get_parent() as CharacterBody2D

const WALK_SPEED := 11.0   # vitesse du cycle de marche
const SWING := 3.5         # amplitude horizontale de la pointe (local)
const LIFT := 3.0          # levée verticale quand la jambe avance (local)
const BLEND_SPEED := 12.0  # lissage marche <-> repos

var _ll_tip: Vector2
var _lr_tip: Vector2
var _phase := 0.0
var _move := 0.0           # 0 = repos, 1 = marche

func _ready() -> void:
	_ll_tip = _leg_left.get_point_position(1)
	_lr_tip = _leg_right.get_point_position(1)

func _process(delta: float) -> void:
	var moving := false
	if _body != null:
		moving = absf(_body.velocity.x) > 15.0 and _body.is_on_floor()

	_move = lerpf(_move, 1.0 if moving else 0.0, clampf(delta * BLEND_SPEED, 0.0, 1.0))
	if moving:
		_phase += delta * WALK_SPEED

	# Jambes en opposition de phase (l'une avance pendant que l'autre recule).
	var sl := sin(_phase) * _move
	var sr := sin(_phase + PI) * _move
	_leg_left.set_point_position(1, _ll_tip + Vector2(sl * SWING, -maxf(sl, 0.0) * LIFT))
	_leg_right.set_point_position(1, _lr_tip + Vector2(sr * SWING, -maxf(sr, 0.0) * LIFT))
