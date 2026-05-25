extends Node2D
class_name Rosace

# ── Une rosace lumineuse pour le décor onirique des Yeux. ──
# 4 styles tirés de assets/raw_art/Les Rosaces.html :
#   1 = Horlogerie du Rêve (3 engrenages emboîtés)
#   2 = Astrolabe Fractal (cercles + triangles + satellites)
#   3 = Fleur de Cils (pétales en ellipses + cœur pulsant)
#   4 = Réseau de Toiles (spirales d'Archimède + rayons)
#
# Tout est tracé dans _draw() — pas d'asset externe. Le glow du
# WorldEnvironment (déjà actif dans LesYeux) amplifie le néon.

@export_range(1, 4) var style: int = 1
@export var radius: float = 50.0
@export var color_main: Color = Color(1.0, 0.7, 0.28)
@export var color_accent: Color = Color(1.0, 0.89, 0.54)
@export var spin_speed: float = 0.3           # rad/s, signé
@export var drift_amp: Vector2 = Vector2(8, 10)
@export var drift_freq: Vector2 = Vector2(0.4, 0.5)
@export var halo_alpha: float = 0.32          # opacité du halo
@export var alpha_mul: float = 1.0            # multiplicateur global (par plan de profondeur)
@export var rng_seed: int = 0

var _t: float = 0.0
var _phase_x: float = 0.0
var _phase_y: float = 0.0
var _base_pos: Vector2 = Vector2.ZERO
# Style 1 seulement : état de rotation indépendant des 3 engrenages
var _gears: Array = []

func _ready() -> void:
	_base_pos = position
	var rng := RandomNumberGenerator.new()
	rng.seed = rng_seed if rng_seed != 0 else hash(str(position))
	_phase_x = rng.randf() * TAU
	_phase_y = rng.randf() * TAU
	if style == 1:
		_setup_horlogerie()
	set_process(true)

func _setup_horlogerie() -> void:
	# Reprend la géométrie du HTML : engrenages emboîtés au module 3.33.
	# Échelle proportionnelle au radius (qui représente le gros engrenage).
	var s := radius / 60.0
	_gears = [
		{
			"pos": Vector2.ZERO, "r": 60.0 * s, "teeth": 36, "tooth_len": 3.0 * s,
			"hands": 12, "hand_len": 50.0 * s, "color": color_main,
			"spin": spin_speed, "rot": 0.0
		},
		{
			"pos": Vector2(65.86, -55.28) * s, "r": 20.0 * s, "teeth": 12, "tooth_len": 3.0 * s,
			"hands": 6, "hand_len": 16.0 * s, "color": color_accent,
			"spin": -spin_speed * 3.0, "rot": deg_to_rad(5.0)
		},
		{
			"pos": Vector2(-70.15, 40.50) * s, "r": 15.0 * s, "teeth": 9, "tooth_len": 3.0 * s,
			"hands": 6, "hand_len": 12.0 * s, "color": color_main,
			"spin": -spin_speed * 4.0, "rot": deg_to_rad(-10.0)
		},
	]

func _process(delta: float) -> void:
	_t += delta
	# Dérive flottante (sinusoïdes décalées) — donne le côté "qui flotte dans le rêve"
	var dx := sin(_t * drift_freq.x + _phase_x) * drift_amp.x
	var dy := sin(_t * drift_freq.y + _phase_y) * drift_amp.y
	position = _base_pos + Vector2(dx, dy)
	if style == 1:
		for g in _gears:
			g["rot"] = g["rot"] + g["spin"] * delta
	else:
		rotation += spin_speed * delta
	queue_redraw()

func _draw() -> void:
	# Shimmer doux sur l'aura (pulse lent)
	var shimmer := 0.82 + 0.18 * sin(_t * 0.9 + _phase_x)
	# Halo en premier (derrière), avec alpha décroissant
	_draw_halo(shimmer)
	match style:
		1: _draw_horlogerie(shimmer)
		2: _draw_astrolabe(shimmer)
		3: _draw_fleur(shimmer)
		4: _draw_reseau(shimmer)

# ── Halo : cercles concentriques translucides, le glow du WorldEnv fait le reste ──
func _draw_halo(shimmer: float) -> void:
	var base := halo_alpha * alpha_mul * shimmer
	var c := color_main
	var rings := 5
	for i in rings:
		var f := float(i) / float(rings)        # 0..0.8
		var r := radius * (1.05 + f * 0.7)
		var a := base * (1.0 - f) * 0.55
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 48, Color(c.r, c.g, c.b, a), 1.6, true)

func _stroke(w: float) -> float:
	return maxf(0.6, radius / 60.0 * w)

func _modc(c: Color, mul_a: float) -> Color:
	return Color(c.r, c.g, c.b, c.a * mul_a)

# ── Style 1 : Horlogerie du Rêve ──
func _draw_horlogerie(shimmer: float) -> void:
	for g in _gears:
		_draw_gear(g, shimmer)

func _draw_gear(g: Dictionary, shimmer: float) -> void:
	var a := alpha_mul * shimmer
	var c: Color = g["color"]
	var col := _modc(c, a)
	var col_dim := _modc(c, a * 0.55)
	var sw := _stroke(0.6)
	var sw_t := _stroke(0.4)
	var center: Vector2 = g["pos"]
	var r: float = g["r"]
	var rot: float = g["rot"]
	# Cercles principal + intérieur
	draw_arc(center, r, 0.0, TAU, 64, col, sw, true)
	draw_arc(center, r * 0.9, 0.0, TAU, 64, col_dim, sw_t, true)
	# Dents triangulaires
	var teeth: int = g["teeth"]
	var tl: float = g["tooth_len"]
	for i in teeth:
		var ang := (float(i) / float(teeth)) * TAU + rot
		var a1 := ang - PI / float(teeth) * 0.45
		var a2 := ang + PI / float(teeth) * 0.45
		var p_tip := center + Vector2(cos(ang), sin(ang)) * (r + tl)
		var pb1 := center + Vector2(cos(a1), sin(a1)) * r
		var pb2 := center + Vector2(cos(a2), sin(a2)) * r
		draw_polyline([pb1, p_tip, pb2, pb1], col, sw_t, true)
	# Aiguilles astrales (du centre vers l'extérieur)
	var hands: int = g["hands"]
	var hl: float = g["hand_len"]
	for i in hands:
		var ang2 := (float(i) / float(hands)) * TAU + PI / float(hands) * 0.5 + rot
		var p := center + Vector2(cos(ang2), sin(ang2)) * hl
		draw_line(center, p, col_dim, sw_t, true)
	# Anneaux intérieurs + cœur
	draw_arc(center, r * 0.23, 0.0, TAU, 32, col, sw_t, true)
	draw_arc(center, r * 0.10, 0.0, TAU, 24, col_dim, sw_t, true)
	draw_circle(center, maxf(1.4, r * 0.04), col)

# ── Style 2 : Astrolabe Fractal ──
func _draw_astrolabe(shimmer: float) -> void:
	var a := alpha_mul * shimmer
	var c1 := _modc(color_main, a)
	var c2 := _modc(color_accent, a)
	var c1d := _modc(c1, 0.55)
	var sw := _stroke(0.6)
	var sw_t := _stroke(0.4)
	var r := radius
	# Grands cercles
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, c1, sw, true)
	draw_arc(Vector2.ZERO, r * 0.86, 0.0, TAU, 64, c1d, sw_t, true)
	# Triangles imbriqués
	var tri_r := r * 0.83
	_draw_triangle(tri_r, c1, sw_t)
	_draw_triangle(-tri_r, c1d, sw_t)
	# Cercle intérieur
	draw_arc(Vector2.ZERO, r * 0.31, 0.0, TAU, 32, c1d, sw_t, true)
	# Satellites en couronne
	var sat_n := 14
	for i in sat_n:
		var ang := (float(i) / float(sat_n)) * TAU
		var pos := Vector2(cos(ang), sin(ang)) * r * 1.0
		draw_arc(pos, maxf(1.8, r * 0.06), 0.0, TAU, 18, c2, sw_t, true)
	# Cœur
	draw_circle(Vector2.ZERO, maxf(1.5, r * 0.035), c1)

func _draw_triangle(size: float, color: Color, width: float) -> void:
	var p1 := Vector2(0, -size)
	var p2 := Vector2(size * 0.866, size * 0.5)
	var p3 := Vector2(-size * 0.866, size * 0.5)
	draw_polyline([p1, p2, p3, p1], color, width, true)

# ── Style 3 : Fleur de Cils ──
func _draw_fleur(shimmer: float) -> void:
	var a := alpha_mul * shimmer
	var cm := _modc(color_main, a)
	var ca := _modc(color_accent, a)
	var sw_t := _stroke(0.45)
	var r := radius
	# Pétales extérieurs (16 ellipses fines, étirées)
	var outer_n := 16
	for i in outer_n:
		var ang := (float(i) / float(outer_n)) * TAU
		var off := Vector2(cos(ang - PI / 2.0), sin(ang - PI / 2.0)) * (r * 0.80)
		_draw_ellipse(off, r * 0.13, r * 0.6, ang, cm, sw_t, 26)
	# Pétales intérieurs (10)
	var inner_n := 10
	for i in inner_n:
		var ang2 := (float(i) / float(inner_n)) * TAU
		var off2 := Vector2(cos(ang2 - PI / 2.0), sin(ang2 - PI / 2.0)) * (r * 0.40)
		_draw_ellipse(off2, r * 0.066, r * 0.30, ang2, ca, sw_t, 22)
	# Anneau central
	draw_arc(Vector2.ZERO, r * 0.30, 0.0, TAU, 32, cm, sw_t, true)
	draw_arc(Vector2.ZERO, r * 0.18, 0.0, TAU, 32, _modc(cm, 0.7), sw_t, true)
	# Cœur pulsant
	var pulse := 1.0 + 0.18 * sin(_t * 1.7 + _phase_x)
	draw_circle(Vector2.ZERO, r * 0.10 * pulse, _modc(ca, 0.35))
	draw_arc(Vector2.ZERO, r * 0.10 * pulse, 0.0, TAU, 24, ca, sw_t, true)
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
	draw_polyline(pts, color, width, true)

# ── Style 4 : Réseau de Toiles ──
func _draw_reseau(shimmer: float) -> void:
	var a := alpha_mul * shimmer
	var cm := _modc(color_main, a)
	var ca := _modc(color_accent, a)
	var sw := _stroke(0.55)
	var sw_t := _stroke(0.35)
	var r := radius
	# 3 spirales d'Archimède décalées de 120°
	var turns := 4
	var max_r := r * 0.78
	var sa := r * 0.03
	var sb := (max_r - sa) / (float(turns) * TAU)
	for k in 3:
		var off := deg_to_rad(120.0 * float(k))
		_draw_spiral(sa, sb, turns, off, _modc(cm, 1.0 - 0.2 * float(k)), sw)
	# 24 rayons droits
	var rays := 24
	var ri := r * 0.20
	var ro := r * 0.98
	for i in rays:
		var ang := (float(i) / float(rays)) * TAU
		var p1 := Vector2(cos(ang), sin(ang)) * ri
		var p2 := Vector2(cos(ang), sin(ang)) * ro
		draw_line(p1, p2, _modc(ca, 0.6), sw_t, true)
	# Cercles d'encadrement
	draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, ca, sw, true)
	draw_arc(Vector2.ZERO, r * 0.46, 0.0, TAU, 32, _modc(ca, 0.7), sw_t, true)
	draw_arc(Vector2.ZERO, r * 0.18, 0.0, TAU, 24, ca, sw_t, true)
	# Cœur pulsant
	var pulse := 1.0 + 0.2 * sin(_t * 1.5 + _phase_y)
	draw_circle(Vector2.ZERO, r * 0.045 * pulse, cm)

func _draw_spiral(a_param: float, b_param: float, turns: int, rot_offset: float, color: Color, width: float) -> void:
	var pts := PackedVector2Array()
	var step := 0.10
	var max_t := float(turns) * TAU
	var t := 0.0
	while t <= max_t:
		var rr := a_param + b_param * t
		pts.append(Vector2(cos(t + rot_offset) * rr, sin(t + rot_offset) * rr))
		t += step
	if pts.size() > 1:
		draw_polyline(pts, color, width, true)
