extends Node

# Émis quand Veilae change de forme (orbe → humanoïde)
signal phase_changed(new_phase: int)

const SAVE_PATH := "user://save_data.tres"

# Phase 1 = orbe d'énergie, Phase 2 = forme humanoïde
var game_phase: int = 1

# Neurones (checkpoints) activés — tableau de dictionnaires {id, position}
var activated_checkpoints: Array = []

# Dernier checkpoint activé (position de respawn)
var last_checkpoint_position: Vector2 = Vector2.ZERO

# Sorts débloqués — ex: ["metal_fusion", "neural_network"]
var unlocked_spells: Array[String] = []

# Souvenirs collectés (narration environnementale)
var collected_memories: Array[String] = []


func _ready() -> void:
	load_game()


# --- Phases ---

func set_phase(new_phase: int) -> void:
	if new_phase == game_phase:
		return
	game_phase = new_phase
	phase_changed.emit(game_phase)
	save_game()


# --- Checkpoints ---

func activate_checkpoint(checkpoint_id: String, position: Vector2) -> void:
	last_checkpoint_position = position
	# Évite les doublons
	for cp in activated_checkpoints:
		if cp["id"] == checkpoint_id:
			return
	activated_checkpoints.append({"id": checkpoint_id, "position": position})
	save_game()


func get_respawn_position() -> Vector2:
	return last_checkpoint_position


# --- Sorts ---

func unlock_spell(spell_id: String) -> void:
	if spell_id not in unlocked_spells:
		unlocked_spells.append(spell_id)
		save_game()


func has_spell(spell_id: String) -> bool:
	return spell_id in unlocked_spells


# --- Souvenirs ---

func collect_memory(memory_id: String) -> void:
	if memory_id not in collected_memories:
		collected_memories.append(memory_id)
		save_game()


# --- Sauvegarde ---

func save_game() -> void:
	var data := {
		"game_phase": game_phase,
		"activated_checkpoints": activated_checkpoints,
		"last_checkpoint_position": {
			"x": last_checkpoint_position.x,
			"y": last_checkpoint_position.y
		},
		"unlocked_spells": unlocked_spells,
		"collected_memories": collected_memories,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK:
		return
	var data: Dictionary = json.get_data()
	game_phase                = data.get("game_phase", 1)
	activated_checkpoints     = data.get("activated_checkpoints", [])
	var raw_spells: Array = data.get("unlocked_spells", [])
	unlocked_spells.clear()
	for s in raw_spells:
		unlocked_spells.append(str(s))
	var raw_memories: Array = data.get("collected_memories", [])
	collected_memories.clear()
	for m in raw_memories:
		collected_memories.append(str(m))
	var cp_pos                = data.get("last_checkpoint_position", {"x": 0, "y": 0})
	last_checkpoint_position  = Vector2(cp_pos["x"], cp_pos["y"])


func reset_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	game_phase               = 1
	activated_checkpoints    = []
	last_checkpoint_position = Vector2.ZERO
	unlocked_spells          = []
	collected_memories       = []
