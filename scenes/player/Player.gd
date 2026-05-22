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

# ---- Variables internes ----
var coyote_timer      := 0.0
var jump_buffer_timer := 0.0
var was_on_floor      := false

var current_hp        := MAX_HP
var iframe_timer      := 0.0


func _ready() -> void:
	# Active le loop du son de marche au runtime (le .import n'est pas modifié)
	if $WalkSound.stream is AudioStreamWAV:
		$WalkSound.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_update_health_display()


func _process(delta: float) -> void:
	# Rotation continue des satellites autour de Zell
	($HealthDisplay as Node2D).rotation += ORBIT_SPEED * delta
	_update_satellite_trails()


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
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	# Debug : F1 = subir 1 dégât, F2 = soigner 1 PV
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F1:
			take_damage(1)
		elif event.keycode == KEY_F2:
			heal(1)


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var mult := 1.0
		if velocity.y > 0.0:
			# Phase de chute : gravité boostée pour un feel plus net
			mult = FALL_GRAVITY_MULT
		elif not Input.is_action_pressed("jump"):
			# Phase d'ascension MAIS saut relâché : gravité fortement boostée → mini-saut
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
	# on plafonne la vitesse verticale (réagit à un relâché même très tardif)
	var jump_cut_cap := JUMP_VELOCITY * JUMP_CUT_MULTIPLIER  # ex: -500 * 0.0 = 0
	if not Input.is_action_pressed("jump") and velocity.y < jump_cut_cap:
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

func take_damage(amount: int) -> void:
	# Pendant les iframes : on ignore les coups
	if iframe_timer > 0.0:
		return
	current_hp = max(current_hp - amount, 0)
	iframe_timer = IFRAME_DURATION
	_update_health_display()
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
