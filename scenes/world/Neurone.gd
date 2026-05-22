extends Node2D

# Checkpoint / point de sauvegarde / point de respawn.
# Au contact + E : active le neurone, soigne Zell, définit son point de respawn.

const PULSE_SPEED       := 1.2     # Cycles par seconde
const IDLE_PULSE_AMOUNT := 0.10
const ACTIVE_PULSE_AMOUNT := 0.20

@onready var halo: Sprite2D = $Halo
@onready var core: Sprite2D = $Core
@onready var prompt: Label = $Prompt

var time_elapsed   := 0.0
var is_activated   := false
var player_in_range: Node = null


func _ready() -> void:
	prompt.visible = false
	$InteractionArea.body_entered.connect(_on_body_entered)
	$InteractionArea.body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	time_elapsed += delta
	# Pulse continu — plus marqué quand activé
	var amount := ACTIVE_PULSE_AMOUNT if is_activated else IDLE_PULSE_AMOUNT
	var pulse: float = 1.0 + amount * sin(time_elapsed * PULSE_SPEED * TAU)
	halo.scale = Vector2(pulse, pulse)

	# Contact + E : 1ʳᵉ fois = activation, fois suivantes = repos
	if player_in_range and Input.is_action_just_pressed("interact"):
		if is_activated:
			_rest()
		else:
			activate()


func _on_body_entered(body: Node) -> void:
	if body.has_method("set_respawn_point"):
		player_in_range = body
		prompt.visible = true


func _on_body_exited(body: Node) -> void:
	if body == player_in_range:
		player_in_range = null
		prompt.visible = false


# Refactor : E à proximité = repos. Première fois, on déclenche aussi l'allumage permanent.
func _rest() -> void:
	if not player_in_range:
		return
	player_in_range.set_respawn_point(global_position)
	if player_in_range.has_method("rest_at_neurone"):
		player_in_range.rest_at_neurone()


func activate() -> void:
	is_activated = true
	# Allume plus fort : halo plus opaque + core plus grand
	halo.modulate = Color(0.85, 0.95, 1.0, 0.85)
	core.modulate = Color(1.0, 1.0, 1.0, 1.0)
	core.scale *= 1.25
	_rest()
