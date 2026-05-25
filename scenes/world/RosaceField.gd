extends Node2D
class_name RosaceField

# ── Peuple un plan de profondeur avec des rosaces variées. ──
# Trois plans (back / mid / front), chacun avec sa propre instance de ce nœud.
# Les paramètres visuels (taille, alpha, halo, désaturation) sont pilotés par
# `depth` pour produire une vraie profondeur onirique style Hollow Knight Dream.

const ROSACE_SCRIPT := preload("res://scenes/world/Rosace.gd")

@export_enum("back", "mid", "front") var depth: String = "mid"
@export var count: int = 10
@export var spawn_seed: int = 1
@export var x_range: Vector2 = Vector2(-3000, 3000)
@export var y_range: Vector2 = Vector2(-340, 300)
@export var enable_connectors: bool = false

# Palette néon élargie (extraite du HTML + variations onirisées)
const PALETTE := [
	Color(1.00, 0.70, 0.28),  # 0 amber
	Color(1.00, 0.89, 0.54),  # 1 amber-2
	Color(0.37, 0.91, 1.00),  # 2 cyan
	Color(0.71, 0.55, 1.00),  # 3 violet
	Color(1.00, 0.48, 0.87),  # 4 magenta
	Color(1.00, 0.95, 1.00),  # 5 opal
	Color(0.25, 1.00, 0.71),  # 6 emerald
	Color(0.60, 1.00, 0.89),  # 7 mint
	Color(0.85, 0.55, 1.00),  # 8 violet doux
	Color(1.00, 0.78, 0.95),  # 9 rose pâle
	Color(0.55, 0.80, 1.00),  # 10 bleu glacé
]
# Appariement main → accent (couleurs qui vont bien ensemble)
const PAIR := [1, 0, 3, 2, 5, 4, 7, 6, 3, 4, 2]

# Couleur cible vers laquelle on désature au fond (violet sombre du décor)
const DREAM_DARK := Color(0.20, 0.10, 0.30)

# État runtime
var _clusters: Array = []        # [[parent_node, orbit_speed], ...]
var _connectors: Array = []      # [[Vector2 p1, Vector2 p2], ...]

func _ready() -> void:
	_build()
	set_process(true)

func _process(delta: float) -> void:
	# Rotation orbitale lente des clusters (les 2-3 rosaces tournent ensemble)
	for c in _clusters:
		c[0].rotation += c[1] * delta

func _build() -> void:
	_clusters.clear()
	_connectors.clear()
	for child in get_children():
		child.queue_free()

	var rng := RandomNumberGenerator.new()
	rng.seed = spawn_seed

	# Paramètres visuels par plan de profondeur
	var size_range: Vector2
	var a_mul: float
	var halo: float
	var spin_mul: float
	var drift_mul: float
	var desat: float
	match depth:
		"back":
			size_range = Vector2(20.0, 35.0)
			a_mul = 0.40
			halo = 0.18
			spin_mul = 0.35
			drift_mul = 0.7
			desat = 0.55
		"front":
			size_range = Vector2(50.0, 90.0)
			a_mul = 1.0
			halo = 0.42
			spin_mul = 1.0
			drift_mul = 1.2
			desat = 0.0
		_:  # "mid"
			size_range = Vector2(35.0, 60.0)
			a_mul = 0.75
			halo = 0.32
			spin_mul = 0.6
			drift_mul = 1.0
			desat = 0.22

	var positions: Array = []

	for i in count:
		# Pas de cluster sur le plan arrière (trop petit pour être lisible)
		var cluster_chance := 0.0 if depth == "back" else 0.28
		if rng.randf() < cluster_chance:
			_spawn_cluster(rng, size_range, a_mul, halo, spin_mul, drift_mul, desat, positions)
		else:
			_spawn_single(rng, size_range, a_mul, halo, spin_mul, drift_mul, desat, positions)

	if enable_connectors and positions.size() > 1:
		_compute_connectors(positions)
		queue_redraw()

func _draw() -> void:
	# Fils de liaison ultrafins entre rosaces proches (effet réseau onirique HK)
	for pair in _connectors:
		draw_line(pair[0], pair[1], Color(0.60, 1.00, 0.89, 0.10), 0.9, true)

# ── Spawn d'une rosace isolée ──
func _spawn_single(rng: RandomNumberGenerator, size_range: Vector2, a_mul: float, halo: float, spin_mul: float, drift_mul: float, desat: float, positions: Array) -> void:
	var ros := Node2D.new()
	ros.set_script(ROSACE_SCRIPT)

	var radius := rng.randf_range(size_range.x, size_range.y)
	var style := rng.randi_range(1, 4)
	var color_idx := rng.randi() % PALETTE.size()
	var c_main := _apply_desat(PALETTE[color_idx], desat)
	var c_accent := _apply_desat(PALETTE[PAIR[color_idx]], desat)
	var px := rng.randf_range(x_range.x, x_range.y)
	var py := _safe_y(rng, radius)
	var spin := rng.randf_range(0.15, 0.5) * spin_mul * (1.0 if rng.randf() > 0.5 else -1.0)
	var d_amp := Vector2(rng.randf_range(4.0, 12.0), rng.randf_range(5.0, 14.0)) * drift_mul
	var d_freq := Vector2(rng.randf_range(0.3, 0.6), rng.randf_range(0.3, 0.55))

	ros.set("style", style)
	ros.set("radius", radius)
	ros.set("color_main", c_main)
	ros.set("color_accent", c_accent)
	ros.set("spin_speed", spin)
	ros.set("drift_amp", d_amp)
	ros.set("drift_freq", d_freq)
	ros.set("halo_alpha", halo)
	ros.set("alpha_mul", a_mul)
	ros.set("rng_seed", rng.randi())
	ros.position = Vector2(px, py)
	add_child(ros)
	positions.append(ros.position)

# ── Spawn d'un cluster : 2 ou 3 rosaces sur un parent qui tourne ensemble ──
func _spawn_cluster(rng: RandomNumberGenerator, size_range: Vector2, a_mul: float, halo: float, spin_mul: float, drift_mul: float, desat: float, positions: Array) -> void:
	var parent := Node2D.new()
	var px := rng.randf_range(x_range.x, x_range.y)
	var py := _safe_y(rng, size_range.y * 1.4)
	parent.position = Vector2(px, py)
	add_child(parent)
	positions.append(parent.position)

	var orbit_speed := rng.randf_range(0.05, 0.16) * (1.0 if rng.randf() > 0.5 else -1.0)
	_clusters.append([parent, orbit_speed])

	var n := 2 + (rng.randi() % 2)             # 2 ou 3
	var cluster_style := rng.randi_range(2, 4) # pas style 1 (Horlogerie est déjà un trio en soi)
	var color_idx := rng.randi() % PALETTE.size()
	var c_main := _apply_desat(PALETTE[color_idx], desat)
	var c_accent := _apply_desat(PALETTE[PAIR[color_idx]], desat)
	var orbit_r := rng.randf_range(size_range.x * 1.0, size_range.y * 1.4)
	var start_angle := rng.randf() * TAU
	for j in n:
		var ros := Node2D.new()
		ros.set_script(ROSACE_SCRIPT)
		var radius := rng.randf_range(size_range.x * 0.7, size_range.y * 0.9)
		var ang := start_angle + (float(j) / float(n)) * TAU
		ros.position = Vector2(cos(ang), sin(ang)) * orbit_r
		ros.set("style", cluster_style)
		ros.set("radius", radius)
		ros.set("color_main", c_main)
		ros.set("color_accent", c_accent)
		ros.set("spin_speed", rng.randf_range(0.2, 0.5) * spin_mul * (1.0 if rng.randf() > 0.5 else -1.0))
		ros.set("drift_amp", Vector2(2.5, 3.5))  # dérive plus discrète dans un cluster
		ros.set("drift_freq", Vector2(0.4, 0.45))
		ros.set("halo_alpha", halo)
		ros.set("alpha_mul", a_mul)
		ros.set("rng_seed", rng.randi())
		parent.add_child(ros)

# Pioche un Y dans la zone autorisée, en réservant la place pour le rayon
func _safe_y(rng: RandomNumberGenerator, r: float) -> float:
	var lo := y_range.x + r
	var hi := y_range.y - r
	if lo >= hi:
		return (y_range.x + y_range.y) * 0.5
	return rng.randf_range(lo, hi)

# Désaturation vers une couleur cible (mix linéaire RGB)
func _apply_desat(c: Color, amount: float) -> Color:
	if amount <= 0.0:
		return c
	return Color(
		lerpf(c.r, DREAM_DARK.r, amount),
		lerpf(c.g, DREAM_DARK.g, amount),
		lerpf(c.b, DREAM_DARK.b, amount),
		c.a
	)

# Fils de liaison entre rosaces proches (max 1 par rosace pour rester sobre)
func _compute_connectors(positions: Array) -> void:
	var max_dist := 380.0
	var used := {}
	for i in positions.size():
		if used.has(i):
			continue
		var best_j := -1
		var best_d := max_dist
		for j in range(i + 1, positions.size()):
			if used.has(j):
				continue
			var d := (positions[i] as Vector2).distance_to(positions[j] as Vector2)
			if d < best_d:
				best_d = d
				best_j = j
		if best_j != -1:
			_connectors.append([positions[i], positions[best_j]])
			used[i] = true
			used[best_j] = true
