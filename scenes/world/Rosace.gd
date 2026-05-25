extends Node2D
class_name Rosace

# ── Une rosace lumineuse pour le décor onirique des Yeux. ──
# Optimisée : tout est dessiné UNE SEULE FOIS au _ready(). La rotation, le
# drift et le shimmer passent par les propriétés transform/modulate du Node2D
# qui ne déclenchent pas de _draw(). Pour le style 1 (Horlogerie), chaque
# engrenage est un sous-Node2D qui tourne indépendamment via sa transform.

@export_range(1, 4) var style: int = 1
@export var radius: float = 50.0
@export var color_main: Color = Color(1.0, 0.7, 0.28)
@export var color_accent: Color = Color(1.0, 0.89, 0.54)
@export var spin_speed: float = 0.3
@export var drift_amp: Vector2 = Vector2(8, 10)
@export var drift_freq: Vector2 = Vector2(0.4, 0.5)
@export var halo_alpha: float = 0.32
@export var alpha_mul: float = 1.0
@export var rng_seed: int = 0

var _t: float = 0.0
var _phase_x: float = 0.0
var _phase_y: float = 0.0
var _base_pos: Vector2 = Vector2.ZERO
var _gears: Array[Node2D] = []
var _gear_spins: Array[float] = []

# ── Sous-classe : un engrenage qui dessine une fois et tourne via transform ──
class GearDrawer extends Node2D:
	var r: float = 20.0
	var teeth: int = 12
	var tooth_len: float = 3.0
	var hands: int = 6
	var hand_len: float = 16.0
	var color: Color = Color.WHITE
	var halo_a: float = 0.0

	func setup(radius_: float, teeth_: int, tooth_len_: float, hands_: int, hand_len_: float, color_: Color, halo_alpha_: float) -> void:
		r = radius_
		teeth = teeth_
		tooth_len = tooth_len_
		hands = hands_
		hand_len = hand_len_
		color = color_
		halo_a = halo_alpha_
		queue_redraw()

	func _draw() -> void:
		var sw := maxf(0.6, r / 60.0 * 0.6)
		var sw_t := maxf(0.6, r / 60.0 * 0.4)
		var c_dim := Color(color.r, color.g, color.b, color.a * 0.55)
		# Halo (3 anneaux concentriques)
		for i in 3:
			var f := float(i) / 3.0
			var rr := r * (1.05 + f * 0.7)
			var a := halo_a * (1.0 - f) * 0.55
			draw_arc(Vector2.ZERO, rr, 0.0, TAU, 28, Color(color.r, color.g, color.b, a), 1.6)
		# Cercles principal + intérieur
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, color, sw)
		draw_arc(Vector2.ZERO, r * 0.9, 0.0, TAU, 32, c_dim, sw_t)
		# Dents triangulaires
		for i in teeth:
			var ang := (float(i) / float(teeth)) * TAU
			var a1 := ang - PI / float(teeth) * 0.45
			var a2 := ang + PI / float(teeth) * 0.45
			var p_tip := Vector2(cos(ang), sin(ang)) * (r + tooth_len)
			var pb1 := Vector2(cos(a1), sin(a1)) * r
			var pb2 := Vector2(cos(a2), sin(a2)) * r
			draw_polyline([pb1, p_tip, pb2, pb1], color, sw_t)
		# Aiguilles
		for i in hands:
			var ang2 := (float(i) / float(hands)) * TAU + PI / float(hands) * 0.5
			var p := Vector2(cos(ang2), sin(ang2)) * hand_len
			draw_line(Vector2.ZERO, p, c_dim, sw_t)
		# Anneaux intérieurs + cœur
		draw_arc(Vector2.ZERO, r * 0.23, 0.0, TAU, 20, color, sw_t)
		draw_circle(Vector2.ZERO, maxf(1.4, r * 0.04), color)


func _ready() -> void:
	_base_pos = position
	var rng := RandomNumberGenerator.new()
	rng.seed = rng_seed if rng_seed != 0 else hash(str(position))
	_phase_x = rng.randf() * TAU
	_phase_y = rng.randf() * TAU
	modulate = Color(1.0, 1.0, 1.0, alpha_mul)
	if style == 1:
		_build_horlogerie()
	# Pour les styles 2-4, _draw sera appelé une fois après _ready (auto-queue_redraw initial)
	set_process(true)

func _build_horlogerie() -> void:
	var s := radius / 60.0
	var defs := [
		{"pos": Vector2.ZERO, "r": 60.0 * s, "teeth": 36, "tl": 3.0 * s, "hands": 12, "hl": 50.0 * s, "color": color_main, "spin": spin_speed, "rot0": 0.0},
		{"pos": Vector2(65.86, -55.28) * s, "r": 20.0 * s, "teeth": 12, "tl": 3.0 * s, "hands": 6, "hl": 16.0 * s, "color": color_accent, "spin": -spin_speed * 3.0, "rot0": deg_to_rad(5.0)},
		{"pos": Vector2(-70.15, 40.50) * s, "r": 15.0 * s, "teeth": 9, "tl": 3.0 * s, "hands": 6, "hl": 12.0 * s, "color": color_main, "spin": -spin_speed * 4.0, "rot0": deg_to_rad(-10.0)},
	]
	for d in defs:
		var g := GearDrawer.new()
		g.position = d["pos"]
		g.rotation = d["rot0"]
		g.setup(d["r"], d["teeth"], d["tl"], d["hands"], d["hl"], d["color"], halo_alpha)
		add_child(g)
		_gears.append(g)
		_gear_spins.append(d["spin"])

func _process(delta: float) -> void:
	_t += delta
	# Dérive flottante
	var dx := sin(_t * drift_freq.x + _phase_x) * drift_amp.x
	var dy := sin(_t * drift_freq.y + _phase_y) * drift_amp.y
	position = _base_pos + Vector2(dx, dy)
	# Rotation
	if style == 1:
		for i in _gears.size():
			_gears[i].rotation += _gear_spins[i] * delta
	else:
		rotation += spin_speed * delta
	# Shimmer doux via modulate (pas de redraw)
	var shimmer := 0.85 + 0.15 * sin(_t * 0.9 + _phase_x)
	modulate.a = alpha_mul * shimmer

# ── _draw appelé une fois après _ready pour styles 2-4 ──
func _draw() -> void:
	match style:
		2: _draw_astrolabe()
		3: _draw_fleur()
		4: _draw_reseau()
	# Style 1 dessine via les GearDrawer enfants, pas ici.
	# Halo : on le dessine pour tous (style 1 a aussi son halo via les GearDrawer)
	if style != 1:
		_draw_halo()

func _draw_halo() -> void:
	var c := color_main
	for i in 3:
		var f := float(i) / 3.0
		var r := radius * (1.05 + f * 0.7)
		var a := halo_alpha * (1.0 - f) * 0.55
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 32, Color(c.r, c.g, c.b, a), 1.6)

func _stroke(w: float) -> float:
	return maxf(0.6, radius / 60.0 * w)

func _modc(c: Color, mul_a: float) -> Color:
	return Color(c.r, c.g, c.b, c.a * mul_a)

# ── Style 2 : Astrolabe Fractal ──
func _draw_astrolabe() -> void:
	var c1 := color_main
	var c2 := color_accent
	var c1d := _modc(c1, 0.55)
	var sw := _stroke(0.6)
	var sw_t := _stroke(0.4)
	var r := radius
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, c1, sw)
	draw_arc(Vector2.ZERO, r * 0.86, 0.0, TAU, 32, c1d, sw_t)
	var tri_r := r * 0.83
	_draw_triangle(tri_r, c1, sw_t)
	_draw_triangle(-tri_r, c1d, sw_t)
	draw_arc(Vector2.ZERO, r * 0.31, 0.0, TAU, 20, c1d, sw_t)
	var sat_n := 14
	for i in sat_n:
		var ang := (float(i) / float(sat_n)) * TAU
		var pos := Vector2(cos(ang), sin(ang)) * r * 1.0
		draw_arc(pos, maxf(1.8, r * 0.06), 0.0, TAU, 12, c2, sw_t)
	draw_circle(Vector2.ZERO, maxf(1.5, r * 0.035), c1)

func _draw_triangle(size: float, color: Color, width: float) -> void:
	var p1 := Vector2(0, -size)
	var p2 := Vector2(size * 0.866, size * 0.5)
	var p3 := Vector2(-size * 0.866, size * 0.5)
	draw_polyline([p1, p2, p3, p1], color, width)

# ── Style 3 : Fleur de Cils ──
func _draw_fleur() -> void:
	var cm := color_main
	var ca := color_accent
	var sw_t := _stroke(0.45)
	var r := radius
	var outer_n := 16
	for i in outer_n:
		var ang := (float(i) / float(outer_n)) * TAU
		var off := Vector2(cos(ang - PI / 2.0), sin(ang - PI / 2.0)) * (r * 0.80)
		_draw_ellipse(off, r * 0.13, r * 0.6, ang, cm, sw_t, 16)
	var inner_n := 10
	for i in inner_n:
		var ang2 := (float(i) / float(inner_n)) * TAU
		var off2 := Vector2(cos(ang2 - PI / 2.0), sin(ang2 - PI / 2.0)) * (r * 0.40)
		_draw_ellipse(off2, r * 0.066, r * 0.30, ang2, ca, sw_t, 14)
	draw_arc(Vector2.ZERO, r * 0.30, 0.0, TAU, 24, cm, sw_t)
	draw_arc(Vector2.ZERO, r * 0.18, 0.0, TAU, 20, _modc(cm, 0.7), sw_t)
	# Cœur statique (plus de pulse pour éviter le redraw)
	draw_circle(Vector2.ZERO, r * 0.10, _modc(ca, 0.35))
	draw_arc(Vector2.ZERO, r * 0.10, 0.0, TAU, 16, ca, sw_t)
	draw_circle(Vector2.ZERO, r * 0.028, ca)

func _draw_ellipse(center: Vector2, rx: float, ry: float, rot: float, color: Color, width: float, segs: int) -> void:
	var pts := PackedVector2Array()
	var cs := cos(rot)
	var sn := sin(rot)
	for i in segs + 1:
		var t := (float(i) / float(segs)) * TAU
		var lx := cos(t) * rx
		var ly := sin(t) * ry
		var x := lx * cs - ly * sn
		var y := lx * sn + ly * cs
		pts.append(center + Vector2(x, y))
	draw_polyline(pts, color, width)

# ── Style 4 : Réseau de Toiles ──
func _draw_reseau() -> void:
	var cm := color_main
	var ca := color_accent
	var sw := _stroke(0.55)
	var sw_t := _stroke(0.35)
	var r := radius
	var turns := 3
	var max_r := r * 0.78
	var sa := r * 0.03
	var sb := (max_r - sa) / (float(turns) * TAU)
	for k in 3:
		var off := deg_to_rad(120.0 * float(k))
		_draw_spiral(sa, sb, turns, off, _modc(cm, 1.0 - 0.2 * float(k)), sw)
	var rays := 18
	var ri := r * 0.20
	var ro := r * 0.98
	for i in rays:
		var ang := (float(i) / float(rays)) * TAU
		var p1 := Vector2(cos(ang), sin(ang)) * ri
		var p2 := Vector2(cos(ang), sin(ang)) * ro
		draw_line(p1, p2, _modc(ca, 0.6), sw_t)
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, ca, sw)
	draw_arc(Vector2.ZERO, r * 0.46, 0.0, TAU, 24, _modc(ca, 0.7), sw_t)
	draw_arc(Vector2.ZERO, r * 0.18, 0.0, TAU, 16, ca, sw_t)
	# Cœur statique
	draw_circle(Vector2.ZERO, r * 0.045, cm)

func _draw_spiral(a_param: float, b_param: float, turns: int, rot_offset: float, color: Color, width: float) -> void:
	var pts := PackedVector2Array()
	var step := 0.20
	var max_t := float(turns) * TAU
	var t := 0.0
	while t <= max_t:
		var rr := a_param + b_param * t
		pts.append(Vector2(cos(t + rot_offset) * rr, sin(t + rot_offset) * rr))
		t += step
	if pts.size() > 1:
		draw_polyline(pts, color, width)
