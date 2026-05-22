extends CharacterBody2D

# ---- Paramètres de mouvement (modifiables sans toucher au code) ----
const SPEED               := 220.0
const ACCELERATION        := 1800.0   # Plus élevé = démarrage plus réactif
const FRICTION            := 1400.0   # Plus élevé = arrêt plus brusque
const JUMP_VELOCITY       := -500.0   # Négatif car Y vers le haut en Godot
const JUMP_CUT_MULTIPLIER := 0.0      # 0.0 = mini-saut quasi-inexistant (Hollow Knight-like). 0.15-0.30 pour plus de marge.
const GRAVITY             := 1200.0
const FALL_GRAVITY_MULT   := 1.8      # Chute plus rapide qu'ascension (feel naturel)
const JUMP_RELEASE_MULT   := 4.0      # Gravité ×N pendant l'ascension si saut relâché (rend le mini-saut vraiment mini)

const COYOTE_TIME         := 0.12     # Secondes de grâce après le bord d'une plateforme
const JUMP_BUFFER_TIME    := 0.10     # Secondes pendant lesquelles le saut est mémorisé
const AIR_CONTROL_MULT    := 0.65     # Accélération en l'air = AIR_CONTROL_MULT × accélération au sol (entre Mario et Hollow Knight)

const JUMP_SOUND_DURATION := 0.25     # Durée max du son de saut (coupe le clic en fin de .wav)

# ---- Paramètres de vie ----
const MAX_HP              := 5        # PV de base (chaque satellite = 1 PV au départ)
const IFRAME_DURATION     := 0.7      # Secondes d'invulnérabilité après un coup pris
const ORBIT_SPEED         := 0.6      # Vitesse de rotation des satellites autour de Zell (radians/s)

# ---- Paramètres de combat ----
const ATTACK_COOLDOWN     := 0.25     # Délai mini entre deux attaques (anti-spam)
const ATTACK_DURATION     := 0.15     # Durée d'activité de la hitbox + visuel
const ATTACK_DAMAGE       := 1
const POGO_VELOCITY       := -650.0   # Rebond vers le haut quand on frappe en bas en l'air
const POGO_PROTECTION     := 0.35     # Durée pendant laquelle la gravité reste normale après un pogo
const KNOCKBACK_FORCE     := 280.0    # Force du recul quand Zell prend un coup

# ---- Variables internes ----
var coyote_timer      := 0.0
var jump_buffer_timer := 0.0
var was_on_floor      := false

var current_hp        := MAX_HP
var iframe_timer      := 0.0

var facing_dir            := 1        # 1 = droite, -1 = gauche (dernière direction visible)
var attack_cooldown_timer := 0.0
var attack_active_timer   := 0.0
var current_attack_dir    := Vector2.RIGHT
var attack_hit_targets    := []        # Cibles déjà touchées pendant l'attaque en cours
var attack_tween: Tween
var pogo_protection_timer := 0.0       # Tant que > 0, la gravité reste normale (protège l'élan du pogo)


func _ready() -> void:
	# Active le loop du son de marche au runtime (le .import n'est pas modifié)
	if $WalkSound.stream is AudioStreamWAV:
		$WalkSound.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_update_health_display()


func _process(delta: float) -> void:
	# Rotation continue des satellites — sens horaire à droite, antihoraire à gauche
	($HealthDisplay as Node2D).rotation += ORBIT_SPEED * float(facing_dir) * delta
	_update_satellite_trails()
	_update_energy_thread()


func _update_energy_thread() -> void:
	# Le fil d'énergie va du centre de Zell au pommeau de l'épée
	var anchor: Node2D = $AttackPivot/HandleAnchor
	$EnergyThread.set_point_position(1, anchor.position.rotated(($AttackPivot as Node2D).rotation) + ($AttackPivot as Node2D).position)


func _update_satellite_trails() -> void:
	# Quand une flammèche passe DEVANT Zell (dans le sens du déplacement),
	# sa simulation s'accélère → particules meurent plus vite → trainée discrète.
	# Quand elle est derrière, trail normal.
	var move_dir: float = signf(velocity.x)
	var rot: float = ($HealthDisplay as Node2D).rotation
	for satellite: GPUParticles2D in $HealthDisplay.get_children():
		if absf(move_dir) < 0.01:
			satellite.speed_scale = 1.0
			continue
		# Position du satellite dans l'espace de Zell (après rotation de HealthDisplay)
		var world_x: float = satellite.position.x * cos(rot) - satellite.position.y * sin(rot)
		if signf(world_x) == move_dir:
			satellite.speed_scale = 3.0   # devant : trail court
		else:
			satellite.speed_scale = 1.0   # derrière : trail normal


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_coyote_time(delta)
	_update_jump_buffer(delta)
	_process_jump()
	_process_horizontal(delta)
	_update_iframes(delta)
	_update_attack(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# Debug : F1 = subir 1 dégât, F2 = soigner 1 PV
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F1:
			take_damage(1)
		elif event.keycode == KEY_F2:
			heal(1)


func _apply_gravity(delta: float) -> void:
	if pogo_protection_timer > 0.0:
		pogo_protection_timer = maxf(pogo_protection_timer - delta, 0.0)
	if not is_on_floor():
		var mult := 1.0
		if velocity.y > 0.0:
			# Phase de chute : gravité boostée pour un feel plus net
			mult = FALL_GRAVITY_MULT
		elif not Input.is_action_pressed("jump") and pogo_protection_timer <= 0.0:
			# Phase d'ascension MAIS saut relâché : gravité fortement boostée → mini-saut
			# (désactivé temporairement après un pogo pour préserver l'élan)
			mult = JUMP_RELEASE_MULT
		velocity.y += GRAVITY * mult * delta


func _update_coyote_time(delta: float) -> void:
	# On vient de quitter le sol → on démarre le timer
	if was_on_floor and not is_on_floor():
		coyote_timer = COYOTE_TIME
	elif is_on_floor():
		coyote_timer = 0.0
	else:
		coyote_timer = maxf(coyote_timer - delta, 0.0)

	# Détection d'atterrissage : on était en l'air, on touche le sol
	if not was_on_floor and is_on_floor():
		$LandBurst.restart()
		$LandSound.play()

	was_on_floor = is_on_floor()


func _update_jump_buffer(delta: float) -> void:
	# On appuie sur saut → on mémorise l'intention
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)


func _process_jump() -> void:
	# Saut autorisé si : sol OU fenêtre coyote active
	var can_jump := is_on_floor() or coyote_timer > 0.0
	if jump_buffer_timer > 0.0 and can_jump:
		velocity.y    = JUMP_VELOCITY
		coyote_timer  = 0.0
		jump_buffer_timer = 0.0
		_play_jump_sound()

	# Saut court : tant que la touche n'est pas maintenue et qu'on monte encore,
	# on plafonne la vitesse verticale (réagit à un relâché même très tardif).
	# Désactivé temporairement après un pogo / un knockback pour préserver l'élan.
	var jump_cut_cap := JUMP_VELOCITY * JUMP_CUT_MULTIPLIER  # ex: -500 * 0.0 = 0
	if not Input.is_action_pressed("jump") and velocity.y < jump_cut_cap and pogo_protection_timer <= 0.0:
		velocity.y = jump_cut_cap


func _play_jump_sound() -> void:
	$JumpSound.play()
	await get_tree().create_timer(JUMP_SOUND_DURATION).timeout
	$JumpSound.stop()


func _process_horizontal(delta: float) -> void:
	# En l'air : accélération et friction réduites (contrôle moins direct qu'au sol)
	var control_mult := 1.0 if is_on_floor() else AIR_CONTROL_MULT
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * control_mult * delta)
		# Retourne le sprite selon la direction du mouvement
		$ZellVisual.scale.x = sign(direction)
	else:
		# Friction : ralentissement progressif jusqu'à l'arrêt (réduite en l'air)
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * control_mult * delta)

	# Mémorise la direction du regard et bascule la pose idle de l'épée si on change de sens
	if direction != 0.0:
		var new_facing := int(signf(direction))
		if new_facing != facing_dir:
			facing_dir = new_facing
			if attack_active_timer <= 0.0:
				_return_sword_to_idle()

	# Trainée de marche : uniquement au sol, quand on bouge réellement
	var is_walking := is_on_floor() and absf(velocity.x) > 20.0
	$ZellVisual/Trail.emitting = is_walking

	# Son de marche : démarre quand on commence à marcher, s'arrête quand on s'arrête
	if is_walking and not $WalkSound.playing:
		$WalkSound.play()
	elif not is_walking and $WalkSound.playing:
		$WalkSound.stop()


# ============================================================
# SYSTÈME DE VIE
# ============================================================

func take_damage(amount: int, from_position: Vector2 = Vector2.ZERO) -> void:
	# Pendant les iframes : on ignore les coups
	if iframe_timer > 0.0:
		return
	current_hp = max(current_hp - amount, 0)
	iframe_timer = IFRAME_DURATION
	_update_health_display()
	# Knockback : pousse Zell à l'opposé de la source du coup
	if from_position != Vector2.ZERO:
		var dir: Vector2 = (global_position - from_position).normalized()
		velocity = dir * KNOCKBACK_FORCE
		velocity.y = minf(velocity.y, -180.0)   # garantit toujours un petit décollage vers le haut
		pogo_protection_timer = POGO_PROTECTION   # protège l'élan du knockback
	if current_hp <= 0:
		_die()


func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, MAX_HP)
	_update_health_display()


func _update_iframes(delta: float) -> void:
	if iframe_timer > 0.0:
		iframe_timer = maxf(iframe_timer - delta, 0.0)
		# Clignotement pendant l'invulnérabilité
		var blink := int(iframe_timer * 12.0) % 2 == 0
		$ZellVisual.modulate.a = 0.3 if blink else 1.0
	else:
		$ZellVisual.modulate.a = 1.0


func _update_health_display() -> void:
	# Allume / éteint les flammèches selon les PV restants
	var satellites := $HealthDisplay.get_children()
	for i in satellites.size():
		var satellite: GPUParticles2D = satellites[i]
		satellite.emitting = i < current_hp


func _die() -> void:
	# Provisoire : on respawn à plein PV (système de mort propre = Objectif 8)
	current_hp = MAX_HP
	_update_health_display()


# ============================================================
# SYSTÈME DE COMBAT
# ============================================================

func _update_attack(delta: float) -> void:
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer = maxf(attack_cooldown_timer - delta, 0.0)

	# Pendant la fenêtre active : scan continu des zones en chevauchement (plus fiable que area_entered)
	if attack_active_timer > 0.0:
		_scan_sword_hits()
		attack_active_timer = maxf(attack_active_timer - delta, 0.0)
		if attack_active_timer <= 0.0:
			$AttackPivot/SwordHitbox.monitoring = false
			$AttackPivot/SlashArc.visible = false
			_return_sword_to_idle()

	# Déclenche une nouvelle attaque si touche pressée et hors cooldown
	if Input.is_action_just_pressed("attack") and attack_cooldown_timer <= 0.0:
		_trigger_attack()


func _trigger_attack() -> void:
	# Détermine la direction du coup (priorité : bas > haut > horizontale)
	var dir := Vector2.RIGHT * facing_dir
	var rotation_rad := 0.0
	if Input.is_action_pressed("look_down"):
		dir = Vector2.DOWN
		rotation_rad = PI / 2.0
	elif Input.is_action_pressed("look_up"):
		dir = Vector2.UP
		rotation_rad = -PI / 2.0
	elif facing_dir < 0:
		rotation_rad = PI

	current_attack_dir = dir
	attack_hit_targets.clear()
	$AttackPivot/SwordHitbox.monitoring = true
	attack_active_timer   = ATTACK_DURATION
	attack_cooldown_timer = ATTACK_COOLDOWN

	# Animation de fente : l'épée vient de "derrière" et arrive à la position d'attaque
	if attack_tween:
		attack_tween.kill()
	var pivot := $AttackPivot as Node2D
	pivot.position = Vector2.ZERO
	pivot.rotation = rotation_rad - 0.6 * (1 if facing_dir > 0 else -1)
	# Slash arc visible le temps du swing, modulate qui fade
	var arc: Polygon2D = $AttackPivot/SlashArc
	arc.visible = true
	arc.modulate.a = 0.9
	attack_tween = create_tween().set_parallel(true)
	attack_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(pivot, "rotation", rotation_rad, ATTACK_DURATION)
	attack_tween.tween_property(arc, "modulate:a", 0.0, ATTACK_DURATION)


func _scan_sword_hits() -> void:
	for area: Area2D in $AttackPivot/SwordHitbox.get_overlapping_areas():
		var target: Node = area.get_parent()
		if target == self or attack_hit_targets.has(target):
			continue
		attack_hit_targets.append(target)
		if target.has_method("take_damage"):
			target.take_damage(ATTACK_DAMAGE, global_position)
		# Pogo : si on a frappé vers le bas, on rebondit (qu'on soit en l'air ou pas)
		if current_attack_dir == Vector2.DOWN:
			velocity.y = POGO_VELOCITY
			pogo_protection_timer = POGO_PROTECTION


func _return_sword_to_idle() -> void:
	# Retour à la pose idle (épée flottante près de Zell)
	if attack_tween:
		attack_tween.kill()
	var pivot := $AttackPivot as Node2D
	var idle_pos := Vector2(15 * facing_dir, 14)
	var idle_rot := 0.6 if facing_dir > 0 else PI - 0.6
	attack_tween = create_tween().set_parallel(true)
	attack_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	attack_tween.tween_property(pivot, "position", idle_pos, 0.2)
	attack_tween.tween_property(pivot, "rotation", idle_rot, 0.2)
