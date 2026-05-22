extends Area2D

# Zone de mort : tout corps qui entre est tué.
# Sert pour les chutes dans le vide, l'eau, la lave, etc.

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.has_method("trigger_death"):
		body.trigger_death()
