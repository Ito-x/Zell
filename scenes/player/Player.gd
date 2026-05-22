extends CharacterBody2D

# ---- Paramètres de mouvement (modifiables sans toucher au code) ----
const SPEED               := 220.0
const ACCELERATION        := 1800.0   # Plus élevé = démarrage plus réactif
const FRICTION            := 1400.0   # Plus élevé = arrêt plus brusque
const JUMP_VELOCITY       := -500.0   # Négatif car Y vers le haut en Godot
const JUMP_CUT_MULTIPLIER := 0.35     # Réduit la vitesse si saut relâché tôt
const GRAVITY             := 1200.0
const FALL_GRAVITY_MULT   := 1.8      # Chute plus rapide qu'ascension (feel naturel)

const COYOTE_TIME         := 0.12     # Secondes de grâce après le bord d'une plateforme
const JUMP_BUFFER_TIME    := 0.10     # Secondes pendant lesquelles le saut est mémorisé
const AIR_CONTROL_MULT    := 0.65     # Accélération en l'air = AIR_CONTROL_MULT × accélération au sol (entre Mario et Hollow Knight)

const JUMP_SOUND_DURATION := 0.25     # Durée max du son de saut (coupe le clic en fin de .wav)

# ---- Variables internes ----
var coyote_timer      := 0.0
var jump_buffer_timer := 0.0
var was_on_floor      := false


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_coyote_time(delta)
	_update_jump_buffer(delta)
	_process_jump()
	_process_horizontal(delta)
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		# Multiplicateur de gravité : chute plus vite qu'on monte
		var mult := FALL_GRAVITY_MULT if velocity.y > 0.0 else 1.0
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


func _play_jump_sound() -> void:
	$JumpSound.play()
	await get_tree().create_timer(JUMP_SOUND_DURATION).timeout
	$JumpSound.stop()

	# Saut court : si on relâche pendant la montée, on coupe l'élan
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= JUMP_CUT_MULTIPLIER


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
	$ZellVisual/Trail.emitting = is_on_floor() and absf(velocity.x) > 20.0
