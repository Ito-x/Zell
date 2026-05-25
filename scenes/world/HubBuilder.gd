@tool
extends Node2D
## Construit la géométrie prototype du hub central (Les Yeux).
## Chaque mur/plateforme = StaticBody2D + CollisionShape2D + Polygon2D.
## On ne touche PAS aux nodes existants (Player, Neurone, Sol, Plafond, Background…).

# --- Couleurs prototype ---
const WALL_COLOR := Color(0.35, 0.40, 0.50)
const PLAT_COLOR := Color(0.45, 0.50, 0.60)
const SMALL_PLAT_COLOR := Color(0.55, 0.60, 0.70)
const DOOR_COLOR := Color(0.8, 0.55, 0.15)
const DOOR_FILL := Color(0.15, 0.12, 0.08)

# --- Dimensions clés ---
# Le Player est à (0, 360), pieds à Y≈385.
# On construit le hub autour de cette position.
const PLATFORM_Y := 385.0       # surface supérieure des plateformes principales
const CEILING_Y := -100.0       # bord inférieur du plafond
const FLOOR_Y := 685.0          # bord supérieur du sol principal
const WALL_THICK := 24.0
const HUB_HALF_W := 1200.0      # demi-largeur du hub

func _ready() -> void:
	# Nettoyer les enfants existants (évite les doublons dans l'éditeur)
	for child in get_children():
		child.queue_free()

	_build_platforms()
	_build_ceiling()
	_build_floor()
	_build_walls()
	_build_door()
	_build_lower_area()
	_build_corridors()

# ===========================================
# PLATEFORMES PRINCIPALES
# ===========================================
func _build_platforms() -> void:
	# 3 plateformes au niveau du joueur (top à PLATFORM_Y)
	# Le Sol existant sert de collision sous le joueur,
	# on ajoute les 2 plateformes latérales + les petites plateformes de saut.

	# Plateforme gauche
	_wall(Vector2(-700, PLATFORM_Y + 12), Vector2(400, WALL_THICK), PLAT_COLOR)

	# Plateforme droite
	_wall(Vector2(700, PLATFORM_Y + 12), Vector2(400, WALL_THICK), PLAT_COLOR)

	# Petites plateformes de saut (gauche → centre)
	for i in range(3):
		var px := -380.0 + i * 80.0
		_wall(Vector2(px, PLATFORM_Y - 15 + i * 10), Vector2(60, 14), SMALL_PLAT_COLOR)

	# Petites plateformes de saut (centre → droite)
	for i in range(3):
		var px := 300.0 + i * 80.0
		_wall(Vector2(px, PLATFORM_Y - 15 + i * 10), Vector2(60, 14), SMALL_PLAT_COLOR)

# ===========================================
# PLAFOND (avec 2 ouvertures pour corridors haut)
# ===========================================
func _build_ceiling() -> void:
	var cy := CEILING_Y - WALL_THICK / 2.0  # centre du mur de plafond

	# Section gauche : X = -1200 à -500
	_wall(Vector2(-850, cy), Vector2(700, WALL_THICK))

	# Ouverture haut-gauche : X = -500 à -300 (200px)

	# Section centre : X = -300 à +300
	_wall(Vector2(0, cy), Vector2(600, WALL_THICK))

	# Ouverture haut-droite : X = +300 à +500 (200px)

	# Section droite : X = +500 à +1200
	_wall(Vector2(850, cy), Vector2(700, WALL_THICK))

# ===========================================
# SOL PRINCIPAL (avec ouvertures pour corridors bas + porte)
# ===========================================
func _build_floor() -> void:
	var fy := FLOOR_Y + WALL_THICK / 2.0

	# Section gauche : X = -1200 à -700
	_wall(Vector2(-950, fy), Vector2(500, WALL_THICK))

	# Ouverture bas-gauche : X = -700 à -500

	# Section centre-gauche : X = -500 à -150
	_wall(Vector2(-325, fy), Vector2(350, WALL_THICK))

	# Ouverture porte/centre : X = -150 à +150

	# Section centre-droite : X = +150 à +500
	_wall(Vector2(325, fy), Vector2(350, WALL_THICK))

	# Ouverture bas-droite : X = +500 à +700

	# Section droite : X = +700 à +1200
	_wall(Vector2(950, fy), Vector2(500, WALL_THICK))

# ===========================================
# MURS LATERAUX (avec ouvertures horizontales)
# ===========================================
func _build_walls() -> void:
	var wx_left := -HUB_HALF_W - WALL_THICK / 2.0
	var wx_right := HUB_HALF_W + WALL_THICK / 2.0

	# Corridor horizontal passe entre Y=100 et Y=300
	var gap_top := 100.0
	var gap_bot := 300.0

	# Mur gauche — section haute (plafond → gap)
	var top_h := gap_top - CEILING_Y
	_wall(Vector2(wx_left, CEILING_Y + top_h / 2.0), Vector2(WALL_THICK, top_h))

	# Mur gauche — section basse (gap → sol)
	var bot_h := FLOOR_Y - gap_bot
	_wall(Vector2(wx_left, gap_bot + bot_h / 2.0), Vector2(WALL_THICK, bot_h))

	# Mur droit — même chose
	_wall(Vector2(wx_right, CEILING_Y + top_h / 2.0), Vector2(WALL_THICK, top_h))
	_wall(Vector2(wx_right, gap_bot + bot_h / 2.0), Vector2(WALL_THICK, bot_h))

# ===========================================
# PORTE (visuel seulement)
# ===========================================
func _build_door() -> void:
	var door_w := 80.0
	var door_h := 60.0
	var dy := FLOOR_Y + WALL_THICK + door_h / 2.0 + 10.0

	var door := Polygon2D.new()
	var hw := door_w / 2.0
	var hh := door_h / 2.0
	door.polygon = PackedVector2Array([
		Vector2(-hw, -hh), Vector2(hw, -hh),
		Vector2(hw, hh), Vector2(-hw, hh)
	])
	door.color = DOOR_FILL
	door.position = Vector2(0, dy)
	add_child(door)

	# Contour orange (4 lignes via Line2D)
	var outline := Line2D.new()
	outline.points = PackedVector2Array([
		Vector2(-hw, -hh), Vector2(hw, -hh),
		Vector2(hw, hh), Vector2(-hw, hh),
		Vector2(-hw, -hh)
	])
	outline.width = 2.0
	outline.default_color = DOOR_COLOR
	outline.position = Vector2(0, dy)
	add_child(outline)

	# Label "PORTE"
	var label := Label.new()
	label.text = "PORTE"
	label.position = Vector2(-20, dy - 10)
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", DOOR_COLOR)
	add_child(label)

# ===========================================
# ZONE INFÉRIEURE (sous le sol principal)
# ===========================================
func _build_lower_area() -> void:
	var lower_floor_y := FLOOR_Y + 400.0
	var lfy := lower_floor_y + WALL_THICK / 2.0

	# Sol inférieur
	_wall(Vector2(0, lfy), Vector2(1000, WALL_THICK))

	# Murs latéraux reliant sol principal → sol inférieur
	var wall_h := lower_floor_y - FLOOR_Y - WALL_THICK
	var wall_cy := FLOOR_Y + WALL_THICK + wall_h / 2.0
	_wall(Vector2(-512, wall_cy), Vector2(WALL_THICK, wall_h))
	_wall(Vector2(512, wall_cy), Vector2(WALL_THICK, wall_h))

# ===========================================
# CORRIDORS STUBS (6 directions)
# ===========================================
func _build_corridors() -> void:
	var stub_len := 2000.0
	var corridor_w := 200.0  # largeur du passage

	# --- HORIZONTAL GAUCHE ---
	var lx := -HUB_HALF_W - WALL_THICK
	var gap_top := 100.0
	var gap_bot := 300.0
	# Mur haut du couloir
	_wall(Vector2(lx - stub_len / 2.0, gap_top - WALL_THICK / 2.0), Vector2(stub_len, WALL_THICK))
	# Mur bas du couloir
	_wall(Vector2(lx - stub_len / 2.0, gap_bot + WALL_THICK / 2.0), Vector2(stub_len, WALL_THICK))
	# Mur de fond
	_wall(Vector2(lx - stub_len - WALL_THICK / 2.0, (gap_top + gap_bot) / 2.0), Vector2(WALL_THICK, gap_bot - gap_top + WALL_THICK))
	# Sol du couloir
	_wall(Vector2(lx - stub_len / 2.0, gap_bot - WALL_THICK / 2.0), Vector2(stub_len, WALL_THICK), PLAT_COLOR)

	# --- HORIZONTAL DROITE ---
	var rx := HUB_HALF_W + WALL_THICK
	_wall(Vector2(rx + stub_len / 2.0, gap_top - WALL_THICK / 2.0), Vector2(stub_len, WALL_THICK))
	_wall(Vector2(rx + stub_len / 2.0, gap_bot + WALL_THICK / 2.0), Vector2(stub_len, WALL_THICK))
	_wall(Vector2(rx + stub_len + WALL_THICK / 2.0, (gap_top + gap_bot) / 2.0), Vector2(WALL_THICK, gap_bot - gap_top + WALL_THICK))
	_wall(Vector2(rx + stub_len / 2.0, gap_bot - WALL_THICK / 2.0), Vector2(stub_len, WALL_THICK), PLAT_COLOR)

	# --- VERTICAL HAUT-GAUCHE ---
	var tl_center_x := -400.0  # centre de l'ouverture (-500 à -300)
	_vert_corridor(tl_center_x, CEILING_Y, -1.0, corridor_w, stub_len)

	# --- VERTICAL HAUT-DROITE ---
	var tr_center_x := 400.0
	_vert_corridor(tr_center_x, CEILING_Y, -1.0, corridor_w, stub_len)

	# --- VERTICAL BAS-GAUCHE ---
	var bl_center_x := -600.0  # centre de l'ouverture (-700 à -500)
	_vert_corridor(bl_center_x, FLOOR_Y + WALL_THICK, 1.0, corridor_w, stub_len)

	# --- VERTICAL BAS-DROITE ---
	var br_center_x := 600.0
	_vert_corridor(br_center_x, FLOOR_Y + WALL_THICK, 1.0, corridor_w, stub_len)

func _vert_corridor(center_x: float, start_y: float, direction: float, width: float, length: float) -> void:
	# direction: -1 = vers le haut, +1 = vers le bas
	var half_w := width / 2.0
	var cy := start_y + direction * length / 2.0

	# Mur gauche
	_wall(Vector2(center_x - half_w - WALL_THICK / 2.0, cy), Vector2(WALL_THICK, length))
	# Mur droit
	_wall(Vector2(center_x + half_w + WALL_THICK / 2.0, cy), Vector2(WALL_THICK, length))
	# Mur de fond
	var end_y := start_y + direction * length
	_wall(Vector2(center_x, end_y + direction * WALL_THICK / 2.0), Vector2(width + WALL_THICK * 2, WALL_THICK))

# ===========================================
# UTILITAIRE : créer un mur/plateforme
# ===========================================
func _wall(pos: Vector2, size: Vector2, color: Color = WALL_COLOR) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = pos

	# Collision
	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	col.shape = rect
	body.add_child(col)

	# Visuel
	var visual := Polygon2D.new()
	var hs := size / 2.0
	visual.polygon = PackedVector2Array([
		Vector2(-hs.x, -hs.y), Vector2(hs.x, -hs.y),
		Vector2(hs.x, hs.y), Vector2(-hs.x, hs.y)
	])
	visual.color = color
	body.add_child(visual)

	add_child(body)
	return body
